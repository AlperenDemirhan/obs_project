# 🎓 OBS Project (PostgreSQL School Information System)

![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-blue?logo=postgresql)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

This repository contains a fully functional **PostgreSQL-based School Information System (OBS Core)** designed for educational database projects.  
It includes schema definitions, sample data, functions, stored procedures, and query examples to simulate a real student information system.

---

## 📁 Project Structure

| File | Description |
|------|--------------|
| **schema.sql** | Defines all tables, keys, relationships, and constraints. |
| **data.sql** | Provides realistic sample data for departments, students, instructors, and courses. |
| **logic.sql** | Contains PL/pgSQL functions & stored procedures (business logic). |
| **views.sql** | Defines database views (e.g., transcript and department course listings). |
| **test_queries.sql** | Demonstrates JOIN, GROUP BY, and function/procedure usage. |

---

## 🧩 Features

✅ Normalized and relational schema (3NF compliant)  
✅ Letter-grade calculation via configurable lookup table  
✅ Stored procedures for student enrollment and grade entry  
✅ Transcript and department-based reporting views  
✅ Complete test queries for verification  

---

## ⚙️ How to Run

You can build the project in any PostgreSQL environment (pgAdmin, DBeaver, or psql CLI).

```bash
# 1️⃣ Create a database
CREATE DATABASE obs_project;

# 2️⃣ Connect to it
\c obs_project

# 3️⃣ Run each script in order
\i schema.sql
\i data.sql
\i logic.sql
\i views.sql
\i test_queries.sql
