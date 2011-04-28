package Git2;

use strict;
use warnings;
use XS::Object::Magic;

our $VERSION = '1.0';

require XSLoader;
XSLoader::load('Git2', $VERSION);

package Git2::Oid::NoFree;

use base 'Git2::Oid';

sub DESTROY {
	# Empty, we can't free this as a parent keeps a ref
}

1;
