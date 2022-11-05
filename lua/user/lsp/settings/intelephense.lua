
return {
  settings = {
    intelephense = {
      stubs = {
        "wordpress-stubs",
		    "wordpress-globals",
		    "woocommerce-stubs",
		    -- "acf-pro",
        "acf-pro-stubs",
      },
	    environment = {
	  	  includePaths = "../../../../vendor/php-stubs/"
	    },
	    files = {
		    maxSize = 5000000;
	    }
    }
  }
  -- settings = {
  --   intelephense = {
  --     stubs = {
  --       "wordpress",
  --       "wordpress-globals",
  --       "wordpress-stubs",
  --       "woocommerce",
  --       "acf-pro",
  --     },
  --     environment = {
  --       includePaths = [
  --          "../../../../vendor/autoload.php",
  --          "../../../../vendor/php-stubs/",
  --          "../../../../vendor/php-stubs",
  --          "../../../../vendor/php-stubs/wordpress-stubs",
  --          "../../../../vendor/php-stubs/wordpress-stubs/",
  --          "../../../../vendor/php-stubs/wordpress-globals/",
  --          "../../../../vendor/php-stubs/wordpress-globals",
  --       ]
  --     },
  --     files = {
  --       maxSize = 500000
  --     },
  --   },
  -- },
}
