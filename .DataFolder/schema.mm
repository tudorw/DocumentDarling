        <map version="1.0.1">
  <node TEXT="document_management_system">
    <node TEXT="users">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="username VARCHAR(255) UNIQUE NOT NULL" />
      <node TEXT="email VARCHAR(255) UNIQUE NOT NULL" />
      <node TEXT="password_hash VARCHAR(255) NOT NULL" />
      <node TEXT="first_name VARCHAR(255) NOT NULL" />
      <node TEXT="last_name VARCHAR(255) NOT NULL" />
      <node TEXT="Indexes">
        <node TEXT="idx_users_email ON users (email)" />
        <node TEXT="idx_users_username ON users (username)" />
      </node>
    </node>
    <node TEXT="documents">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="title VARCHAR(255) NOT NULL" />
      <node TEXT="content TEXT NOT NULL" />
      <node TEXT="doc_type VARCHAR(255) NOT NULL" />
      <node TEXT="created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" />
      <node TEXT="approval_status VARCHAR(255) NOT NULL DEFAULT 'pending'" />
      <node TEXT="compliance_status VARCHAR(255) NOT NULL DEFAULT 'pending'" />
      <node TEXT="author_id INT NOT NULL REFERENCES users (id)" />
      <node TEXT="template_id INT REFERENCES templates (id)" />
      <node TEXT="Indexes">
        <node TEXT="idx_documents_author_id ON documents (author_id)" />
        <node TEXT="idx_documents_template_id ON documents (template_id)" />
        <node TEXT="idx_documents_approval_status ON documents (approval_status)" />
        <node TEXT="idx_documents_compliance_status ON documents (compliance_status)" />
      </node>
    </node>
    <node TEXT="templates">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="name VARCHAR(255) NOT NULL UNIQUE" />
      <node TEXT="content TEXT NOT NULL" />
      <node TEXT="guidelines TEXT" />
    </node>
    <node TEXT="suggestions">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="suggestion TEXT NOT NULL" />
      <node TEXT="status VARCHAR(255) NOT NULL DEFAULT 'pending'" />
      <node TEXT="feedback TEXT" />
      <node TEXT="document_id INT NOT NULL REFERENCES documents (id)" />
      <node TEXT="author_id INT NOT NULL REFERENCES users (id)" />
      <node TEXT="Indexes">
        <node TEXT="idx_suggestions_document_id ON suggestions (document_id)" />
        <node TEXT="idx_suggestions_author_id ON suggestions (author_id)" />
        <node TEXT="idx_suggestions_status ON suggestions (status)" />
      </node>
    </node>
    <node TEXT="document_versions">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="document_id INT NOT NULL REFERENCES documents (id)" />
      <node TEXT="title VARCHAR(255) NOT NULL" />
      <node TEXT="content TEXT NOT NULL" />
      <node TEXT="created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" />
      <node TEXT="version_number INT NOT NULL" />
      <node TEXT="author_id INT NOT NULL REFERENCES users (id)" />
    </node>
    <node TEXT="document_tags">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="name VARCHAR(255) NOT NULL UNIQUE" />
      <node TEXT="description TEXT" />
    </node>
  <node TEXT="document_tags_association">
      <node TEXT="document_id INT NOT NULL REFERENCES documents (id)" />
      <node TEXT="document_tag_id INT NOT NULL REFERENCES document_tags (id)" />
      <node TEXT="PRIMARY KEY (document_id, document_tag_id)" />
    </node>
    <node TEXT="document_history">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="document_id INT NOT NULL REFERENCES documents (id)" />
      <node TEXT="user_id INT NOT NULL REFERENCES users (id)" />
      <node TEXT="timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" />
      <node TEXT="description TEXT NOT NULL" />
      <node TEXT="action VARCHAR(255) NOT NULL" />
    </node>
    <node TEXT="roles">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="name VARCHAR(255) NOT NULL UNIQUE" />
      <node TEXT="permissions TEXT NOT NULL" />
    </node>
    <node TEXT="users_roles">
      <node TEXT="user_id INT NOT NULL REFERENCES users (id)" />
      <node TEXT="role_id INT NOT NULL REFERENCES roles (id)" />
      <node TEXT="PRIMARY KEY (user_id, role_id)" />
    </node>
    <node TEXT="ai_models">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="name VARCHAR(255) NOT NULL" />
      <node TEXT="version VARCHAR(255) NOT NULL" />
      <node TEXT="performance_metrics TEXT NOT NULL" />
    </node>
    <node TEXT="document_approvals">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="document_id INT NOT NULL REFERENCES documents (id)" />
      <node TEXT="approver_id INT NOT NULL REFERENCES users (id)" />
      <node TEXT="approval_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" />
      <node TEXT="approval_status VARCHAR(255) NOT NULL" />
      <node TEXT="comments TEXT" />
      <node TEXT="ai_assisted BOOLEAN NOT NULL DEFAULT FALSE" />
      <node TEXT="tone_check BOOLEAN" />
      <node TEXT="content_check BOOLEAN" />
    </node>
    <node TEXT="notifications">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="recipient_id INT NOT NULL REFERENCES users (id)" />
      <node TEXT="content TEXT NOT NULL" />
      <node TEXT="timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" />
      <node TEXT="read_status BOOLEAN NOT NULL DEFAULT FALSE" />
    </node>
    <node TEXT="document_reviews">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="document_id INT NOT NULL REFERENCES documents (id)" />
      <node TEXT="reviewer_id INT NOT NULL REFERENCES users (id)" />
      <node TEXT="review_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" />
      <node TEXT="review_status VARCHAR(255) NOT NULL" />
      <node TEXT="comments TEXT" />
    </node>
    <node TEXT="ai_analysis_requests">
      <node TEXT="id SERIAL PRIMARY KEY" />
      <node TEXT="document_id INT NOT NULL REFERENCES documents (id)" />
      <node TEXT="status VARCHAR(255) NOT NULL DEFAULT 'pending'" />
      <node TEXT="created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" />
      <node TEXT="analysis_result TEXT" />
      <node TEXT="Indexes">
        <node TEXT="idx_ai_analysis_requests_document_id ON ai_analysis_requests (document_id)" />
      <node TEXT="idx_ai_analysis_requests_status ON ai_analysis_requests (status)" />
      </node>
    </node>
  </node>
</map>
