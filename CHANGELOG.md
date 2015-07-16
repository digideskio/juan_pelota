Version v1.1.0 - July 16, 2015
================================================================================

Changed
--------------------------------------------------------------------------------
  * filtered_arguments so that it works on hashes
  * Exceptions to always raise the same exception
  * Failed jobs to return the message and the backtrace

Fixed
--------------------------------------------------------------------------------
  * Filtering of deeply nested filtered arguments

Version v1.0.0 - July 8, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * .ctags configuration file

Fixed
--------------------------------------------------------------------------------
  * args being treated as a Hash when they're an Array
  * Shadowing outer local variable

Version v0.0.4 - March 26, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * Deploy script
  * circle.yml
  * Rubygems settings

Version v0.0.3 - March 4, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * Rubocop disabler for long methods
  * check to ignore filtered_workers in the logger
  * check to skip logging for filetered_workers in the middleware
  * filtered_arguments to the middleware logger
  * A configuration file with filtered_arguments + filtered_workers

Version v0.0.2 - February 25, 2015
================================================================================

Added
--------------------------------------------------------------------------------
  * Logging middleware for sidekiq

Changed
--------------------------------------------------------------------------------
  * Logger to better handle arguments

Uncategorized
--------------------------------------------------------------------------------
  * Bumped version
  * Fix accidental missing `=`
  * Added support for fail status. #1
  * Add support for retry hashes. #1
  * Add support for retry hashes. #1
  * Upped version to 0.0.10
  * Fix(#1): Logging Exceptions
  * Bumped version to 0.0.9
  * Log worker class name so we can filter on it.
  * Simplify message parsing.
  * Bumped version to 0.0.7
  * Parse severity correctly.
  * Bumped version to 0.0.6
  * Remove carriage returns from log output.
  * Bumped version to 0.0.5
  * Changed config format to comply with @ notation in LogStash.
  * Bumped version to 0.0.4
  * Fix parsing for runtime, status when the status is reported failure.
  * Updated version to 0.0.3
  * Adds newlines to logs.
  * Updated version.
  * Fixes small bug.
  * Update README.md
  * Update README.md
  * Update README.md
  * Fixed dependencies.
  * Updated docs.
  * tests and fixes.
  * Basic logging in JSON format.
  * Init gem.

