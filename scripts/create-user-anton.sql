-- Create user Anton Komarov (anton@b2storefront.com) with admin rights
-- Run this in Supabase Dashboard → SQL Editor
-- Replace 'YourTempPassword123!' with the desired initial password

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

DO $$
DECLARE
  v_user_id UUID := gen_random_uuid();
  v_password TEXT := 'YourTempPassword123!';  -- Change this before running
  v_encrypted_pw TEXT := crypt(v_password, gen_salt('bf'));
BEGIN
  -- 1. Insert the user into auth.users
  INSERT INTO auth.users (
    id,
    instance_id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at
  )
  VALUES (
    v_user_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'anton@b2storefront.com',
    v_encrypted_pw,
    NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"first_name": "Anton", "last_name": "Komarov"}',
    NOW(),
    NOW()
  );

  -- 2. Link an identity so the user can sign in
  INSERT INTO auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at
  )
  VALUES (
    v_user_id,
    v_user_id,
    format('{"sub": "%s", "email": "anton@b2storefront.com"}', v_user_id)::jsonb,
    'email',
    v_user_id::text,
    NOW(),
    NOW(),
    NOW()
  );

  -- 3. The trigger will create the sales row automatically.
  --    Grant admin rights (trigger gives admin only to first user)
  UPDATE public.sales
  SET administrator = true
  WHERE user_id = v_user_id;

END $$;
