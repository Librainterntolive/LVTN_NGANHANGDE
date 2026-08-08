CREATE TABLE IF NOT EXISTS audit_logs (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  actor_user_id BIGINT UNSIGNED NOT NULL,
  action VARCHAR(80) NOT NULL,
  entity_type VARCHAR(50) NOT NULL,
  entity_id BIGINT UNSIGNED NOT NULL DEFAULT 0,
  description VARCHAR(500) NOT NULL DEFAULT '',
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  INDEX idx_audit_logs_actor_user_id (actor_user_id),
  INDEX idx_audit_logs_action (action),
  INDEX idx_audit_logs_entity_type (entity_type),
  INDEX idx_audit_logs_entity_id (entity_id),
  INDEX idx_audit_logs_created_at (created_at)
);
