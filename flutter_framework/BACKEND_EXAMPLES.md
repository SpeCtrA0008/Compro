# Contoh Server Backend untuk IoT

Contoh implementasi backend sederhana untuk menerima dan menyimpan data dari IoT device.

## Opsi 1: Node.js + Express + SQLite

### 1. Setup Project

```bash
mkdir watrie-backend
cd watrie-backend
npm init -y
npm install express sqlite3 cors body-parser
```

### 2. Buat `server.js`

```javascript
const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const port = 8080;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Database setup
const db = new sqlite3.Database('./watrie.db', (err) => {
  if (err) console.error(err.message);
  console.log('Connected to SQLite database.');
});

// Create table
db.run(`CREATE TABLE IF NOT EXISTS sensor_readings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ph REAL NOT NULL,
  suhu REAL NOT NULL,
  mineral REAL NOT NULL,
  tanggal TEXT NOT NULL
)`);

// Routes

// GET all readings
app.get('/api/readings', (req, res) => {
  const { date } = req.query;
  
  let sql = 'SELECT * FROM sensor_readings ORDER BY tanggal DESC';
  let params = [];
  
  if (date) {
    sql = 'SELECT * FROM sensor_readings WHERE DATE(tanggal) = ? ORDER BY tanggal DESC';
    params = [date];
  }
  
  db.all(sql, params, (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

// POST new reading (dari IoT device)
app.post('/api/readings', (req, res) => {
  const { ph, suhu, mineral } = req.body;
  const tanggal = new Date().toISOString();
  
  db.run(
    'INSERT INTO sensor_readings (ph, suhu, mineral, tanggal) VALUES (?, ?, ?, ?)',
    [ph, suhu, mineral, tanggal],
    function(err) {
      if (err) {
        res.status(500).json({ error: err.message });
        return;
      }
      res.json({ id: this.lastID, ph, suhu, mineral, tanggal });
    }
  );
});

// GET readings by date range
app.get('/api/readings/range', (req, res) => {
  const { start, end } = req.query;
  
  db.all(
    'SELECT * FROM sensor_readings WHERE DATE(tanggal) BETWEEN ? AND ? ORDER BY tanggal DESC',
    [start, end],
    (err, rows) => {
      if (err) {
        res.status(500).json({ error: err.message });
        return;
      }
      res.json(rows);
    }
  );
});

// DELETE old readings (optional - untuk cleanup)
app.delete('/api/readings/old', (req, res) => {
  const { days } = req.query || 30;
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() - days);
  
  db.run(
    'DELETE FROM sensor_readings WHERE DATE(tanggal) < ?',
    [cutoffDate.toISOString().split('T')[0]],
    function(err) {
      if (err) {
        res.status(500).json({ error: err.message });
        return;
      }
      res.json({ deleted: this.changes });
    }
  );
});

app.listen(port, () => {
  console.log(`Watrie API server running on http://localhost:${port}`);
});
```

### 3. Jalankan Server

```bash
node server.js
```

### 4. Test dengan curl

```bash
# POST data baru
curl -X POST http://localhost:8080/api/readings \
  -H "Content-Type: application/json" \
  -d '{"ph": 7.2, "suhu": 28.5, "mineral": 125.0}'

# GET semua data
curl http://localhost:8080/api/readings

# GET data tanggal tertentu
curl "http://localhost:8080/api/readings?date=2025-10-20"
```

## Opsi 2: Python Flask + PostgreSQL

### 1. Setup

```bash
pip install flask flask-cors psycopg2-binary
```

### 2. Buat `app.py`

```python
from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Database connection
def get_db():
    return psycopg2.connect(
        dbname="watrie",
        user="postgres",
        password="password",
        host="localhost"
    )

# Create table
def init_db():
    conn = get_db()
    cur = conn.cursor()
    cur.execute('''
        CREATE TABLE IF NOT EXISTS sensor_readings (
            id SERIAL PRIMARY KEY,
            ph REAL NOT NULL,
            suhu REAL NOT NULL,
            mineral REAL NOT NULL,
            tanggal TIMESTAMP NOT NULL
        )
    ''')
    conn.commit()
    cur.close()
    conn.close()

@app.route('/api/readings', methods=['GET'])
def get_readings():
    date = request.args.get('date')
    conn = get_db()
    cur = conn.cursor()
    
    if date:
        cur.execute('''
            SELECT * FROM sensor_readings 
            WHERE DATE(tanggal) = %s 
            ORDER BY tanggal DESC
        ''', (date,))
    else:
        cur.execute('SELECT * FROM sensor_readings ORDER BY tanggal DESC')
    
    rows = cur.fetchall()
    cur.close()
    conn.close()
    
    readings = []
    for row in rows:
        readings.append({
            'id': row[0],
            'ph': row[1],
            'suhu': row[2],
            'mineral': row[3],
            'tanggal': row[4].isoformat()
        })
    
    return jsonify(readings)

@app.route('/api/readings', methods=['POST'])
def add_reading():
    data = request.json
    ph = data.get('ph')
    suhu = data.get('suhu')
    mineral = data.get('mineral')
    tanggal = datetime.now()
    
    conn = get_db()
    cur = conn.cursor()
    cur.execute(
        'INSERT INTO sensor_readings (ph, suhu, mineral, tanggal) VALUES (%s, %s, %s, %s) RETURNING id',
        (ph, suhu, mineral, tanggal)
    )
    reading_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    
    return jsonify({
        'id': reading_id,
        'ph': ph,
        'suhu': suhu,
        'mineral': mineral,
        'tanggal': tanggal.isoformat()
    }), 201

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=8080, debug=True)
```

### 3. Jalankan

```bash
python app.py
```

## Opsi 3: PHP + MySQL (Simple)

### 1. Buat `api.php`

```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "watrie";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed"]));
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    $date = isset($_GET['date']) ? $_GET['date'] : null;
    
    if ($date) {
        $sql = "SELECT * FROM sensor_readings WHERE DATE(tanggal) = ? ORDER BY tanggal DESC";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $date);
    } else {
        $sql = "SELECT * FROM sensor_readings ORDER BY tanggal DESC";
        $stmt = $conn->prepare($sql);
    }
    
    $stmt->execute();
    $result = $stmt->get_result();
    
    $readings = [];
    while($row = $result->fetch_assoc()) {
        $readings[] = $row;
    }
    
    echo json_encode($readings);
    
} elseif ($method == 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $ph = $data['ph'];
    $suhu = $data['suhu'];
    $mineral = $data['mineral'];
    $tanggal = date('Y-m-d H:i:s');
    
    $sql = "INSERT INTO sensor_readings (ph, suhu, mineral, tanggal) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ddds", $ph, $suhu, $mineral, $tanggal);
    
    if ($stmt->execute()) {
        echo json_encode([
            "id" => $stmt->insert_id,
            "ph" => $ph,
            "suhu" => $suhu,
            "mineral" => $mineral,
            "tanggal" => $tanggal
        ]);
    } else {
        echo json_encode(["error" => "Failed to insert"]);
    }
}

$conn->close();
?>
```

### 2. Setup Database

```sql
CREATE DATABASE watrie;
USE watrie;

CREATE TABLE sensor_readings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ph FLOAT NOT NULL,
    suhu FLOAT NOT NULL,
    mineral FLOAT NOT NULL,
    tanggal DATETIME NOT NULL
);
```

## Deploy ke Cloud

### Heroku (Node.js)

```bash
# Install Heroku CLI
heroku login
heroku create watrie-api
git push heroku main
```

### Railway

1. Push code ke GitHub
2. Connect Railway to your repo
3. Deploy otomatis

### DigitalOcean App Platform

1. Push code ke GitHub
2. Create new app di DigitalOcean
3. Link repository
4. Deploy

## Monitoring & Logging

Tambahkan logging untuk debugging:

```javascript
// Di Express
const morgan = require('morgan');
app.use(morgan('combined'));
```

## Security Best Practices

1. **API Key Authentication**

```javascript
app.use((req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  if (apiKey !== process.env.API_KEY) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  next();
});
```

2. **Rate Limiting**

```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api/', limiter);
```

3. **Input Validation**

```javascript
app.post('/api/readings', (req, res) => {
  const { ph, suhu, mineral } = req.body;
  
  if (typeof ph !== 'number' || ph < 0 || ph > 14) {
    return res.status(400).json({ error: 'Invalid pH value' });
  }
  
  // ... similar validation for other fields
});
```
