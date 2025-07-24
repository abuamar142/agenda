# OAuth Browser Flow Implementation

## Overview

This document describes how the Google OAuth authentication flow has been implemented to open an
external browser on Android and handle the callback properly. The implementation uses
**session-based authentication** without local caching for enhanced security.

## Authentication Strategy

### Session-Based Authentication (No Local Cache)

- **Login**: Always requires browser OAuth flow (no cached credentials)
- **Session Persistence**: Relies on Supabase session management
- **Auto-login**: If user has valid Supabase session, automatically redirects to home
- **Logout**: Completely clears session and requires fresh login

### Benefits

- Enhanced security (no sensitive data cached locally)
- Always fresh authentication
- Consistent user experience
- Automatic session validation

## Implementation Details

### 1. Remote Data Source Changes

The `AuthRemoteDataSourceImpl.signInWithGoogle()` method now:

- Uses `authScreenLaunchMode: LaunchMode.externalApplication` to force opening in external browser
- Implements a timeout mechanism (30 seconds) to wait for authentication completion
- Polls for auth state changes every 500ms until user is authenticated or timeout occurs
- Provides better error messages for different failure scenarios

```dart
final response = await supabaseClient.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: 'com.abuamar.agenda.agenda://auth/callback',
  authScreenLaunchMode: LaunchMode.externalApplication,
);
```

### 2. Deep Link Configuration

The Android manifest is already configured with the proper intent filter:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="com.abuamar.agenda.agenda" />
</intent-filter>
```

### 3. User Experience Improvements

- **Loading Message**: Updated to show "Opening browser for authentication..."
- **Info Snackbar**: Shows informative message about browser opening
- **Timeout Handling**: 30-second timeout with clear error message
- **Progress Feedback**: Visual feedback during the entire OAuth flow

## User Flow

### First Time Login

1. User opens app → Splash screen → Auth screen (no valid session)
2. User taps "Continue with Google" button
3. App shows info snackbar: "A browser will open for Google authentication..."
4. Loading indicator appears with message "Opening browser for authentication..."
5. External browser opens with Google OAuth page
6. User completes authentication in browser
7. Browser redirects to `com.abuamar.agenda.agenda://auth/callback`
8. App receives the deep link and processes the authentication
9. App polls for auth state changes until user is authenticated
10. Success snackbar shows "Welcome back, [User Name]!"
11. App navigates to home screen

### Subsequent App Opens (Session Still Valid)

1. User opens app → Splash screen checks Supabase session
2. Valid session found → Direct navigation to home screen
3. No cache used, but Supabase session persists

### Logout Flow

1. User taps logout
2. App clears Supabase session and any local data
3. App navigates to auth screen
4. Next login requires full browser OAuth flow again

## Error Handling

The implementation handles several error scenarios:

- **OAuth Cancelled**: When user cancels the browser flow
- **Authentication Timeout**: If no auth state change occurs within 30 seconds
- **Network Issues**: Proper error propagation from Supabase
- **Deep Link Issues**: Fallback error messages

## Testing

To test the OAuth flow:

1. Run the app on Android device/emulator
2. Tap "Continue with Google"
3. Verify browser opens externally
4. Complete Google authentication
5. Verify app receives callback and user is logged in

## Dependencies

- `supabase_flutter: ^2.5.6` - OAuth provider with browser launch mode support
- `google_sign_in: ^6.2.1` - Google Sign-In SDK (already configured)

## Security Considerations

- Deep link scheme is app-specific: `com.abuamar.agenda.agenda`
- OAuth redirect URI matches the configured deep link
- Timeout prevents indefinite waiting
- Proper error handling prevents information leakage
