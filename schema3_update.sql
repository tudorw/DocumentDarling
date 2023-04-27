-- Add new columns to the documents table
ALTER TABLE documents
ADD COLUMN created_by INT REFERENCES users (id),
ADD COLUMN last_modified_by INT REFERENCES users (id),
ADD COLUMN last_modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN status VARCHAR(255) NOT NULL DEFAULT 'draft',
ADD COLUMN compliance_status VARCHAR(255) NOT NULL DEFAULT 'pending review';

-- Create a view for documents with "pending approval" status
CREATE VIEW pending_approval_documents AS
SELECT *
FROM documents
WHERE status = 'pending approval';

-- Create a stored procedure for documents with "pending approval" status
DELIMITER //
CREATE PROCEDURE get_pending_approval_documents()
BEGIN
  SELECT *
  FROM documents
  WHERE status = 'pending approval';
END //
DELIMITER ;

-- Trigger for updating last_modified_by and last_modified_at when a document is created or modified
DELIMITER //
CREATE TRIGGER update_document_modification
BEFORE INSERT OR UPDATE ON documents
FOR EACH ROW
BEGIN
  SET NEW.last_modified_by = (SELECT id FROM users WHERE username = CURRENT_USER());
  SET NEW.last_modified_at = CURRENT_TIMESTAMP;
END //
DELIMITER ;
