-- GM Account Bindings Table
-- Links GM accounts to their personal accounts for zone restriction enforcement
-- Database: xidb

-- ============================================================================
-- GM ACCOUNT BINDINGS TABLE
-- Used to link GM accounts to personal (non-GM) accounts
-- Zone restrictions prevent characters from linked accounts being in the same zone
-- ============================================================================
CREATE TABLE IF NOT EXISTS gm_account_bindings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    gm_account_id INT NOT NULL COMMENT 'The GM account ID',
    personal_account_id INT NOT NULL COMMENT 'The linked personal account ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When the binding was created',
    created_by_char_id INT NOT NULL COMMENT 'Character ID of GM who created the binding',
    created_by_name VARCHAR(50) NOT NULL COMMENT 'Name of GM who created the binding',
    notes VARCHAR(255) DEFAULT NULL COMMENT 'Optional notes about this binding',
    UNIQUE KEY uk_gm_personal (gm_account_id, personal_account_id),
    INDEX idx_gm_account (gm_account_id),
    INDEX idx_personal_account (personal_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
