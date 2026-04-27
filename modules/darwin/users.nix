{myvars, ...}: {
  system.primaryUser = myvars.username;

  users.users.${myvars.username} = {
    home = "/Users/${myvars.username}";
    description = myvars.userfullname;
  };
}
