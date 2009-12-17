
use strict;
use warnings;

use Test::More tests => 25;

BEGIN {
    use_ok('File::Path::Hashed', qw/make_hash_path/);
    use_ok('File::Path', qw/remove_tree/);
    use_ok('File::Spec');
    use_ok('File::Basename', qw/dirname/);
}

my $base = File::Spec->catfile(File::Spec->tmpdir()
    , 'file-path-hashed-test-' . $$);

foreach my $num  (1..10) {
    my $path = make_hash_path(
        base_dir => $base,
        filename => $num . '.txt',
        depth    => $num,
        length   => (($num % 3) + 1),
    );
    ok(defined $path, 'path returned:' . $path);
    my $dir = dirname($path);
    ok(-d $dir, "created: $dir");
}

ok(remove_tree($base), "removed:$base");

