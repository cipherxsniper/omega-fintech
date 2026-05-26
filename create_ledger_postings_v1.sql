CREATE TABLE IF NOT EXISTS ledger_postings (
    posting_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL,
    sequence_number BIGINT NOT NULL,

    account_type TEXT NOT NULL,
    account_id UUID NOT NULL,

    direction TEXT NOT NULL CHECK (direction IN ('DEBIT', 'CREDIT')),
    amount NUMERIC NOT NULL CHECK (amount >= 0),

    currency TEXT DEFAULT 'USD',

    created_at TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (event_id) REFERENCES omega_events(event_id)
);

CREATE INDEX IF NOT EXISTS idx_ledger_postings_event_id ON ledger_postings(event_id);
CREATE INDEX IF NOT EXISTS idx_ledger_postings_account ON ledger_postings(account_id);
CREATE INDEX IF NOT EXISTS idx_ledger_postings_sequence ON ledger_postings(sequence_number);
