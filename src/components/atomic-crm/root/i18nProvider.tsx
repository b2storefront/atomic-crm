import { mergeTranslations } from "ra-core";
import polyglotI18nProvider from "ra-i18n-polyglot";
import englishMessages from "ra-language-english";
import { raSupabaseEnglishMessages } from "ra-supabase-language-english";

const raSupabaseEnglishMessagesOverride = {
  "ra-supabase": {
    auth: {
      password_reset: "Check your emails for a Reset Password message.",
    },
  },
  resources: {
    contacts: {
      name: "Unit Proposed",
      fields: {
        first_name: "Property / Building",
        last_name: "Unit Number",
      },
    },
    companies: {
      name: "Prospective Tenant",
      fields: {},
    },
  },
};

export const i18nProvider = polyglotI18nProvider(
  () => {
    return mergeTranslations(
      englishMessages,
      raSupabaseEnglishMessages,
      raSupabaseEnglishMessagesOverride,
    );
  },
  "en",
  [{ locale: "en", name: "English" }],
  { allowMissing: true },
);
