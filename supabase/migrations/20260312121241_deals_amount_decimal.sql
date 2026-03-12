-- Allow decimal values for deal amounts (e.g. 1234.56)
ALTER TABLE "public"."deals"
  ALTER COLUMN "amount" TYPE numeric USING amount::numeric;
