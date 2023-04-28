-- Create a database for storing documents
CREATE DATABASE document_management_system;

-- Use the database
USE document_management_system;

-- Create tables
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL
);

CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_username ON users (username);

CREATE TABLE documents (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  doc_type VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  approval_status VARCHAR(255) NOT NULL DEFAULT 'pending',
  compliance_status VARCHAR(255) NOT NULL DEFAULT 'pending',
  author_id INT NOT NULL REFERENCES users (id),
  template_id INT REFERENCES templates (id)
);

CREATE INDEX idx_documents_author_id ON documents (author_id);
CREATE INDEX idx_documents_template_id ON documents (template_id);
CREATE INDEX idx_documents_approval_status ON documents (approval_status);
CREATE INDEX idx_documents_compliance_status ON documents (compliance_status);

CREATE TABLE templates (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  content TEXT NOT NULL,
  guidelines TEXT
);

CREATE TABLE suggestions (
  id SERIAL PRIMARY KEY,
  suggestion TEXT NOT NULL,
  status VARCHAR(255) NOT NULL DEFAULT 'pending',
  feedback TEXT,
  document_id INT NOT NULL REFERENCES documents (id),
  author_id INT NOT NULL REFERENCES users (id)
);

CREATE INDEX idx_suggestions_document_id ON suggestions (document_id);
CREATE INDEX idx_suggestions_author_id ON suggestions (author_id);
CREATE INDEX idx_suggestions_status ON suggestions (status);

CREATE TABLE document_versions (
  id SERIAL PRIMARY KEY,
  document_id INT NOT NULL REFERENCES documents (id),
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  version_number INT NOT NULL,
  author_id INT NOT NULL REFERENCES users (id)
);

CREATE TABLE document_tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE document_tags_association (
  document_id INT NOT NULL REFERENCES documents (id),
  document_tag_id INT NOT NULL REFERENCES document_tags (id),
  PRIMARY KEY (document_id, document_tag_id)
);

CREATE TABLE document_history (
  id SERIAL PRIMARY KEY,
  document_id INT NOT NULL REFERENCES documents (id),
  user_id INT NOT NULL REFERENCES users (id),
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  description TEXT NOT NULL,
  action VARCHAR(255) NOT NULL
);

CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  permissions TEXT NOT NULL
);

CREATE TABLE users_roles (
  user_id INT NOT NULL REFERENCES users (id),
  role_id INT NOT NULL REFERENCES roles (id),
  PRIMARY KEY (user_id, role_id)
);

CREATE TABLE ai_models (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  version VARCHAR(255) NOT NULL,
  performance_metrics TEXT NOT NULL
);

CREATE TABLE document_approvals (
  id SERIAL PRIMARY KEY,
  document_id INT NOT NULL REFERENCES documents (id),
  approver_id INT NOT NULL REFERENCES users (id),
  approval_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  approval_status VARCHAR(255) NOT NULL,
  comments TEXT,
  ai_assisted BOOLEAN NOT NULL DEFAULT FALSE,
  tone_check BOOLEAN,
  content_check BOOLEAN
);

CREATE TABLE notifications (
  id SERIAL PRIMARY KEY,
  recipient_id INT NOT NULL REFERENCES users (id),
  content TEXT NOT NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_status BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE document_reviews (
  id SERIAL PRIMARY KEY,
  document_id INT NOT NULL REFERENCES documents (id),
  reviewer_id INT NOT NULL REFERENCES users (id),
  review_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  review_status VARCHAR(255) NOT NULL,
  comments TEXT
);

CREATE TABLE ai_analysis_requests (
  id SERIAL PRIMARY KEY,
  document_id INT NOT NULL REFERENCES documents (id),
  status VARCHAR(255) NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  analysis_result TEXT
);

CREATE INDEX idx_ai_analysis_requests_document_id ON ai_analysis_requests (document_id);
CREATE INDEX idx_ai_analysis_requests_status ON ai_analysis_requests (status);

