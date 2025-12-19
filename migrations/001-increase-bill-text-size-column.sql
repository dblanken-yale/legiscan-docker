-- Migration: Increase bill_text_size column size
-- Date: 2025-12-18
-- Reason: bill_text_size column (mediumint) has max value of 16,777,215 bytes
--         Some bill texts exceed this size, causing import errors
-- Fix: Change to int(10) UNSIGNED for max value of 4,294,967,295 bytes

ALTER TABLE ls_bill_text
MODIFY COLUMN bill_text_size int(10) UNSIGNED NOT NULL DEFAULT 0;
