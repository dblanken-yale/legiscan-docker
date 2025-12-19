-- Migration: Upgrade all mediumint columns to int
-- Date: 2025-12-18
-- Reason: mediumint columns have max value of 16,777,215
--         Some data (bill_text_size, amendment_size, supplement_size) can exceed this
--         Upgrading all mediumint columns to int for consistency and future-proofing
-- Fix: Change all mediumint(8) UNSIGNED to int(10) UNSIGNED
--       Max value increases from 16,777,215 to 4,294,967,295

-- Table: ls_bill
ALTER TABLE ls_bill
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_amendment
ALTER TABLE ls_bill_amendment
MODIFY COLUMN amendment_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN amendment_size int(10) UNSIGNED NOT NULL DEFAULT 0;

-- Table: ls_bill_calendar
ALTER TABLE ls_bill_calendar
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_history
ALTER TABLE ls_bill_history
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_progress
ALTER TABLE ls_bill_progress
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_reason
ALTER TABLE ls_bill_reason
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_referral
ALTER TABLE ls_bill_referral
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_sast
ALTER TABLE ls_bill_sast
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN sast_bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_sponsor
ALTER TABLE ls_bill_sponsor
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_subject
ALTER TABLE ls_bill_subject
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN subject_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_supplement
ALTER TABLE ls_bill_supplement
MODIFY COLUMN supplement_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN supplement_size int(10) UNSIGNED NOT NULL DEFAULT 0;

-- Table: ls_bill_text
ALTER TABLE ls_bill_text
MODIFY COLUMN text_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN bill_text_size int(10) UNSIGNED NOT NULL DEFAULT 0;

-- Table: ls_bill_vote
ALTER TABLE ls_bill_vote
MODIFY COLUMN roll_call_id int(10) UNSIGNED NOT NULL,
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_bill_vote_detail
ALTER TABLE ls_bill_vote_detail
MODIFY COLUMN roll_call_id int(10) UNSIGNED NOT NULL;

-- Table: ls_ignore
ALTER TABLE ls_ignore
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_monitor
ALTER TABLE ls_monitor
MODIFY COLUMN bill_id int(10) UNSIGNED NOT NULL;

-- Table: ls_people
ALTER TABLE ls_people
MODIFY COLUMN votesmart_id int(10) UNSIGNED NOT NULL DEFAULT 0,
MODIFY COLUMN knowwho_pid int(10) UNSIGNED NOT NULL DEFAULT 0;

-- Table: ls_signal
ALTER TABLE ls_signal
MODIFY COLUMN object_id int(10) UNSIGNED NOT NULL;

-- Table: ls_subject
ALTER TABLE ls_subject
MODIFY COLUMN subject_id int(10) UNSIGNED NOT NULL;
