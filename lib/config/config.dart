class Config {
  static const BACKEND_URL = String.fromEnvironment('APP_BACKEND_URL',
      defaultValue: 'https://simple-graphql-auth.fly.dev/graphql');
}
