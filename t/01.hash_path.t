
use strict;
use warnings;

use Test::More tests => 13;

BEGIN {
    use_ok('File::Path::Hashed', qw/hash_path/);
}

like(hash_path(filename => 'x', depth => 1, length => 1)
    , qr|/[a-z0-9]/x$|, 'hash 1 1');
like(hash_path(filename => 'x', depth => 2, length => 1)
    , qr|/[a-z0-9]/[a-z0-9]/x$|, 'hash 2 1');
like(hash_path(filename => 'x', depth => 3, length => 1)
    , qr|/[a-z0-9]/[a-z0-9]/[a-z0-9]$|, 'hash 3 1');

like(hash_path(filename => 'x', depth => 1, length => 1)
    , qr|/[a-z0-9]/x$|, 'hash 1 1');
like(hash_path(filename => 'x', depth => 2, length => 2)
    , qr|/[a-z0-9]{2}/[a-z0-9]{2}/x$|, 'hash 2 2');
like(hash_path(filename => 'x', depth => 3, length => 3)
    , qr|/[a-z0-9]{3}/[a-z0-9]{3}/[a-z0-9]{3}/x$|, 'hash 3 3');

like(hash_path(filename => 'x', depth => 2, length => 10)
    , qr|/[a-z0-9]{10}/[a-z0-9]{10}/x$|, 'hash 2 10');

# fail tests
eval { hash_path(depth => 3, length => 3); };
ok($@, 'no filename');
eval { hash_path(filename => 'x', depth => 0, length => 3); };
ok($@, 'depth 0');
eval { hash_path(filename => 'x', depth => 3, length => 0); };
ok($@, 'length 0');
eval { hash_path(filename => 'x', depth => 33, length => 1); };
ok($@, 'too deep');
eval { hash_path(filename => 'x', depth => 1, length => 33); };
ok($@, 'too long');

