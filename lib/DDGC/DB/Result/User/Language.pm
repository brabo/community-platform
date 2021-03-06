package DDGC::DB::Result::User::Language;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'user_language';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column language_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

# column users_id => {
	# data_type => 'bigint',
	# is_nullable => 0,
# };

column username => {
	data_type => 'text',
	is_nullable => 0,
};

# 1 for basic ability - enough to understand written material or simple questions in this language.
# 2 for intermediate ability - enough for editing or discussions.
# 3 for advanced level - though you can write in this language with no problem, some small errors might occur.
# 4 for 'near-native' level - although it's not your first language from birth, your ability is something like that of a native speaker.
# 5 for native - you have been grown up with this language in your environment 
# 6 for professional proficiency - you are earning your money with work in this language (like writer, translator, ...)

column grade => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 1,
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

#belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'user', 'DDGC::DB::Result::User', { 'foreign.username' => 'self.username' };
belongs_to 'language', 'DDGC::DB::Result::Language', 'language_id';

use overload '""' => sub {
	my $self = shift;
	return 'User-Language #'.$self->id;
}, fallback => 1;

1;
