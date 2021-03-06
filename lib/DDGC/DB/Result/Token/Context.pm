package DDGC::DB::Result::Token::Context;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'token_context';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

unique_column key => {
	data_type => 'text',
	is_nullable => 0,
};

column name => {
	data_type => 'text',
	is_nullable => 0,
};

column description => {
	data_type => 'text',
	is_nullable => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column source_language_id => {
	data_type => 'int',
	is_nullable => 0,
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

has_many 'tokens', 'DDGC::DB::Result::Token', 'token_context_id';
has_many 'token_context_languages', 'DDGC::DB::Result::Token::Context::Language', 'token_context_id';

belongs_to 'source_language', 'DDGC::DB::Result::Language', 'source_language_id';

many_to_many 'languages', 'token_context_languages', 'language';

use overload '""' => sub {
	my $self = shift;
	return 'Token-Context '.$self->name.' #'.$self->id;
}, fallback => 1;

sub update_token_languages {
	my $self = shift;

	my @languages = $self->languages->all;
	my @tokens = $self->tokens->all;
	
	for my $t (@tokens) {
		for my $l (@languages) {
			$t->find_or_create_related('token_languages',{
				language_id => $l->id,
			},{
				key => 'token_language_token_id_language_id',
			});
		}
	}

}

1;
