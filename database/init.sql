-- Wager Database Schema

CREATE DATABASE IF NOT EXISTS wager_db;
USE wager_db;

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username    VARCHAR(50)  NOT NULL UNIQUE,
  email       VARCHAR(255) NOT NULL UNIQUE,
  password    VARCHAR(255) NOT NULL,
  balance     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  avatar_url  VARCHAR(500),
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Wagers table
CREATE TABLE IF NOT EXISTS wagers (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  creator_id   INT UNSIGNED NOT NULL,
  title        VARCHAR(255) NOT NULL,
  description  TEXT,
  target       TEXT NOT NULL,
  amount       DECIMAL(10,2) NOT NULL,
  deadline     DATETIME NOT NULL,
  status       ENUM('open', 'active', 'completed', 'failed', 'cancelled') NOT NULL DEFAULT 'open',
  proof_url    VARCHAR(500),
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Wager participants (challengers / witnesses)
CREATE TABLE IF NOT EXISTS wager_participants (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  wager_id   INT UNSIGNED NOT NULL,
  user_id    INT UNSIGNED NOT NULL,
  role       ENUM('challenger', 'witness') NOT NULL DEFAULT 'challenger',
  agreed     BOOLEAN NOT NULL DEFAULT FALSE,
  joined_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_participant (wager_id, user_id),
  FOREIGN KEY (wager_id) REFERENCES wagers(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id     INT UNSIGNED NOT NULL,
  wager_id    INT UNSIGNED,
  type        ENUM('deposit', 'withdrawal', 'wager_lock', 'wager_win', 'wager_loss') NOT NULL,
  amount      DECIMAL(10,2) NOT NULL,
  description VARCHAR(255),
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)  REFERENCES users(id)   ON DELETE CASCADE,
  FOREIGN KEY (wager_id) REFERENCES wagers(id)  ON DELETE SET NULL
);

-- Indexes
CREATE INDEX idx_wagers_creator   ON wagers(creator_id);
CREATE INDEX idx_wagers_status    ON wagers(status);
CREATE INDEX idx_transactions_user ON transactions(user_id);
