class Logger {
  static bool _isInitialized = false;
  
  static void init() {
    _isInitialized = true;
    info('Logger initialized');
  }
  
  static void info(String message) {
    if (_isInitialized) {
      print('[INFO] $message');
    }
  }
  
  static void warning(String message) {
    if (_isInitialized) {
      print('[WARNING] $message');
    }
  }
  
  static void error(String message) {
    if (_isInitialized) {
      print('[ERROR] $message');
    }
  }
  
  static void debug(String message) {
    if (_isInitialized) {
      print('[DEBUG] $message');
    }
  }
}