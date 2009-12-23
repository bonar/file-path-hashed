
use inc::Module::Install;

name     'File-Path-Hashed';
license  'perl';
version  '0.02';
abstract_from 'lib/File/Path/Hashed.pm';

requires      'File::Path'     => '2.07';
requires      'File::Spec'     => '0';
requires      'File::Basename' => '0';
requires      'Digest::MD5'    => '0';
requires      'Carp'           => '0';
test_requires 'Test::More'     => '0';

WriteAll;

