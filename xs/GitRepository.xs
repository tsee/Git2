#include "git2-perl.h"


MODULE = Git2::Repository  PACKAGE = Git2::Repository  PREFIX = git_repository_


NO_OUTPUT int
git_repository_open(SV *class, OUTLIST git_repository_class *repo, const char *path)
	C_ARGS: &repo, path

	POSTCALL:
        GIT2PERL_CROAK(RETVAL);


NO_OUTPUT int
git_repository_init(SV *class, OUTLIST git_repository_class *repo, const char *path, unsigned is_bare)
	C_ARGS: &repo, path, is_bare

	POSTCALL:
        GIT2PERL_CROAK(RETVAL);


git_odb*
git_repository_database (git_repository *repo)


SV*
lookup (git_repository *repo, git_oid *id, int type)
	PREINIT:
		git_object *object;
		int code;

	CODE:
		code = git_object_lookup(&object, repo, id, type);
		GIT2PERL_CROAK(code);

		switch (type) {
			case GIT_OBJ_BLOB:
				GIT2PERL_BLESS_FROM_CLASSNAME(object, "Git2::Blob");
			break;

			case GIT_OBJ_COMMIT:
				GIT2PERL_BLESS_FROM_CLASSNAME(object, "Git2::Commit");
			break;

			default:
				GIT2PERL_BLESS_FROM_CLASSNAME(object, "Git2::Object");
			break;
		}

	OUTPUT:
		RETVAL


void
DESTROY(git_repository *repo)
    CODE:
        git_repository_free(repo);
