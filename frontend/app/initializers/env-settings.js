import ENV from "../config/environment";

export function initialize(/* application */) {
  if (ENV.environment !== "test") {
    /* eslint-disable no-undef  */
    $.getJSON({
      url: "/api/env_settings",
      async: false,
      success: function(envSettings) {
        ENV.sentryDsn = envSettings.sentry;
        ENV.currentUserId = envSettings.current_user.id;
        ENV.currentUserRole = envSettings.current_user.role;
        ENV.currentUserGivenname = envSettings.current_user.givenname;
        ENV.preferredLocale = envSettings.current_user.preferred_locale;
        ENV.lastLoginMessage = envSettings.last_login_message;
        ENV.appVersion = envSettings.version;
        ENV.CSRFToken = envSettings.csrf_token;
      }
    });
    /* eslint-enable no-undef  */
  }
}

export default {
  initialize
};
