#include <stdio.h>
#include <ctemplate.h>

int main(int argc, char *args[])
{
	printf("Content-Type: text/html\n\n");

	TMPL_varlist *mylist;
	mylist = TMPL_add_var(0, "var1", "value1", 0);
	TMPL_write("templates/candice.template.html", 0, 0, mylist, stdout, stderr);
	TMPL_free_varlist(mylist);

	return 0;
}
