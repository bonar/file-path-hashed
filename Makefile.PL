
use inc::Module::Install;

name     'File-Path-Hashed';
license  'perl';
version  '0.01';
abstract_from 'lib/File/Path/Hashed.pm';

requires      'File::Path' => '0';
test_requires 'Test::More'       => '0';

WriteAll;

