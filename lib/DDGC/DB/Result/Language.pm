package DDGC::DB::Result::Language;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'language';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

#
# gettext information page about locale definition
# http://www.gnu.org/s/hello/manual/gettext/Locale-Names.html
#

# German in Germany
unique_column name_in_english => {
	data_type => 'text',
	is_nullable => 0,
};

# Deutsch in Deutschland
column name_in_local => {
	data_type => 'text',
	is_nullable => 0,
};

# de_DE
unique_column locale => {
	data_type => 'text',
	is_nullable => 0,
};

column flagicon => {
	data_type => 'text',
	is_nullable => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column updated => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

has_many 'token_languages', 'DDGC::DB::Result::Token::Language', 'language_id';
has_many 'user_languages', 'DDGC::DB::Result::User::Language', 'language_id';
has_many 'token_contexts', 'DDGC::DB::Result::Token::Context', 'source_language_id';

many_to_many 'users', 'user_languages', 'user';

use overload '""' => sub {
	my $self = shift;
	return 'Language '.$self->name_in_english.' with locale '.$self->locale.' #'.$self->id;
}, fallback => 1;

1;
