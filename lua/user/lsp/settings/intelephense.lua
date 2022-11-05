
local basepath = stdpath("config")

return {
  settings = {
    intelephense = {
      stubs = {
        "wordpress-stubs",
        "woocommerce-stubs",
        "acf-pro-stubs",
      },
      environment = {
        includePaths = [
           "../../../../vendor/autoload.php",
           "../../../../vendor/php-stubs/",
           "../../../../vendor/php-stubs",
           "../../../../vendor/php-stubs/wordpress-stubs",
           "../../../../vendor/php-stubs/wordpress-stubs/",
           "../../../../vendor/php-stubs/wordpress-globals/",
           "../../../../vendor/php-stubs/wordpress-globals",
        ]
      },
      files = {
        maxSize = 500000
      },
    },
  },
}
