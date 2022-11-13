<?php

require_once get_stylesheet_directory() . '/vendor/autoload.php';
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;



add_action('admin_menu','create_theme_actions_page');
function create_theme_actions_page(){
    add_menu_page(
        'Theme Actions', // page title
        'Theme Actions', // menu title
        'administrator', // capability
        'theme-actions-page', // menu slug
        'show_ajax_amazon_import_page', // function
        'dashicons-editor-code', //icon
        2 //position
    );
}

function show_ajax_amazon_import_page(){
    ?>
    <div class="wrap">
        <h1><strong>AJAX Amazon Product Import</strong></h1>
        <p>Import Products with no memory limit.</p>
        <form enctype="multipart/form-data" method="POST" action="">
            <label for="csv_file">Import Products: </label><br />
            <input type="file" name="csv_file" id="csv_file" multiple="false" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" required />
            <input type="submit" value="Upload" name="upload_csv" class="button" />
        </form>
    </div>
    <?php

    if (isset($_REQUEST['upload_csv'])) {
        $csv_file = $_FILES['csv_file'];

        $spreadsheet = new Spreadsheet();
        $inputFileType = 'Xlsx';
        $inputFileName = $csv_file['tmp_name'];

        $reader = \PhpOffice\PhpSpreadsheet\IOFactory::createReader($inputFileType);
        $reader->setReadDataOnly(true);
        $worksheet = $reader->load($inputFileName);
        $full_sheet = $worksheet->getActiveSheet()->toArray();
        $skus = '';
        foreach ($full_sheet as $row) {
            $sku = $row[0];
            if( strpos($sku, '"') !== FALSE ){
                $skus .= "'" . $sku . "',";
            } else {
                $skus .= '"' . $sku . '",';
            }
        }
        ?>
        <script src="<?php echo get_stylesheet_directory_uri(); ?>/js/axios.min.js"></script>
        <script type="text/javascript">
            var skus = [<?php echo $skus ?>];
            var count = 0;
            function call_api(id) {
                var url = '<?php echo admin_url('admin-ajax.php') ?>?action=ajax_amazon_import_call';
                axios.get(url + '&id=' + id).then(function(res){
                    if(res.data.status){
                        console.log(id)
                        count++;
                        if(count < skus.length){
                            call_api(skus[count])
                        }
                    } else {
                        console.log(id)
                    }
                }).catch(function(err){
                    console.log(err)
                });
            }
            call_api(skus[count])
        </script>
        <?php
    }
}




function ajax_amazon_import_call(){
    echo json_encode(array(
        'status' => true,
        'message' => 'Success',
        'data' => $_GET,
    ));
    exit(0);
}
add_action('wp_ajax_ajax_amazon_import_call', 'ajax_amazon_import_call');
add_action('wp_ajax_nopriv_ajax_amazon_import_call', 'ajax_amazon_import_call');






function show_theme_actions_page(){ ?>
    <div class="wrap">
        <h1>Theme Actions</h1><br />
        <form enctype="multipart/form-data" method="POST" action="">
            <label for="csv_file">Import Products: </label><br />
            <input type="file" name="csv_file" id="csv_file" multiple="false" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" required />
            <input type="submit" value="Upload" name="upload_csv" class="button" />
        </form>
    </div>
    <?php
    if (isset($_REQUEST['upload_csv'])) {
        $csv_file = $_FILES['csv_file'];

        $spreadsheet = new Spreadsheet();
        $inputFileType = 'Xlsx';
        $inputFileName = $csv_file['tmp_name'];

        $reader = \PhpOffice\PhpSpreadsheet\IOFactory::createReader($inputFileType);
        $reader->setReadDataOnly(true);
        $worksheet = $reader->load($inputFileName);
        $data = $worksheet->getActiveSheet()->toArray();
        $count = 0;
        foreach ($data as $row) {
            $count = $count + 1;
            if ( $count > 1 ) {
                $prodTitle = $row[0];
                $prodCategory = $row[1];
                $prodSubCategory = $row[2];
                $prodSKU = $row[3];
                $prodASIN = $row[4];
                $prodMRP = $row[5];
                $prodSP = $row[6] == 0 ? 100 : $row[6]; // Selling Price
                $prodLink = $row[7];
                $prodDesc = $row[8];
                $prodHSN = $row[9];
                $prodHeight = $row[10];
                $prodWidth = $row[11];
                $prodLength = $row[12];
                $prodWeight = $row[13];
                $prodExcerpt = '<ul class="prod-points">';
                $prodExcerpt .= empty($row[14]) ? '' : '<li>' . $row[14] . '</li>';
                $prodExcerpt .= empty($row[15]) ? '' : '<li>' . $row[15] . '</li>';
                $prodExcerpt .= empty($row[16]) ? '' : '<li>' . $row[16] . '</li>';
                $prodExcerpt .= empty($row[17]) ? '' : '<li>' . $row[17] . '</li>';
                $prodExcerpt .= empty($row[18]) ? '' : '<li>' . $row[18] . '</li>';
                $prodExcerpt .= '</ul>';

                global $wpdb;
                $existing_prod_id = $wpdb->get_var( $wpdb->prepare( "SELECT post_id FROM $wpdb->postmeta WHERE meta_key='_sku' AND meta_value='%s' LIMIT 1", $prodSKU ) );
                echo "HELLO". $existing_prod_id;
                if($existing_prod_id){
                    // for existing product, just add images
                    if($prodLink != ''){
                        // update_data_from_url($existing_prod_id, $prodASIN);
                    }
                } else {
                    // create parent category
                    if(!empty( $prodCategory )){
                        wp_insert_term( $prodCategory, 'product_cat', array(
                            'parent' => 0, // optional
                        ) );
                    }
                    $category = get_term_by( 'name', $prodCategory, 'product_cat' );

                    // create sub category
                    if(!empty( $prodSubCategory )){
                        wp_insert_term( $prodSubCategory, 'product_cat', array(
                            'parent' => $category->term_id,
                        ) );
                    }
                    $subCategory = get_term_by( 'name', $prodSubCategory, 'product_cat' );


                    // create product
                    // kses_remove_filters();
                    $post_id = wp_insert_post( array(
                        'post_title' => $prodTitle,
                        'post_content' => $prodDesc,
                        'post_excerpt' => $prodExcerpt,
                        'post_status' => 'publish',
                        'post_type' => 'product',
                    ) );
                    // kses_init_filters();
                    wp_set_object_terms( $post_id, 'simple', 'product_type' );
                    wp_set_object_terms( $post_id, [ $category->term_id, $subCategory->term_id ], 'product_cat' );
                    update_post_meta( $post_id, '_visibility', 'visible' );
                    update_post_meta( $post_id, '_regular_price', $prodMRP );
                    update_post_meta( $post_id, '_sale_price', $prodSP );
                    update_post_meta( $post_id, '_price', $prodSP );
                    update_post_meta( $post_id, '_weight', $prodWeight );
                    update_post_meta( $post_id, '_length', $prodLength );
                    update_post_meta( $post_id, '_width', $prodWidth );
                    update_post_meta( $post_id, '_height', $prodHeight );
                    update_post_meta( $post_id, '_sku', $prodSKU );

                    update_field( 'asin', $prodASIN , $post_id );
                    update_field( 'hsn', $prodHSN , $post_id );
                    update_field( 'product_link', $prodLink , $post_id );

                    if($prodLink != ''){
                        get_images_from_url($post_id, $prodLink);
                    }

                }
            } else {
                echo '<p>skiping first row as it is header</p>';
            }
        }
    }
}



function update_data_from_url($prod_id, $prodASIN){
        $response = execute_curl($prodASIN);

        // decode in json to use like an object with arrows
        $response = json_decode($response);


        $my_post = array(
              'ID' =>  $prod_id,
              'post_title'    => $response->productTitle,
        );

        // wp_update_post( $my_post );

        $str = '';
        for($i = 0; $i < count($response->productDetails); $i++){
            $str = $str .'<div><strong>'. $response->productDetails[$i]->name ."</strong> : ".$response->productDetails[$i]->value."</div>";
        }
        // echo $str;
        update_field( 'product_details', $str , $prod_id );

        if(count($response->variations) > 0){
            wp_set_object_terms( $prod_id, 'variable', 'product_type' );

            $variations = $response->variations;

            for($j = 0; $j < count($variations); $j++){
                for($k = 0; $k < count($response->variations[$j]->values); $k++){
                    if($k == 0){
                        // The variation data
                        $variation_data =  array(
                            'attributes' => array(
                                'size'  => str_replace(",","",$response->variations[$j]->values[$k]->value)
                            ),
                            'sku'           => '',
                            'regular_price' => $response->retailPrice,
                            'sale_price'    => $response->price,
                            'stock_qty'     => '',
                            'var_desc'      => $response->variations[$j]->values[$k]->asin,
                        );

                        // The function to be run
                        create_product_variation( $prod_id, $variation_data );
                    } else {
                        print_r($response->variations[$j]->values[$k]->value);
                        echo "</br>".$response->variations[$j]->values[$k]->asin."</br>"."</br>";

                        if($response->variations[$j]->values[$k]->asin != ''){
                            $response_var = execute_curl($response->variations[$j]->values[$k]->asin);
                            echo $response_var."</br></br>";
                            $response_var = json_decode($response_var);

                            // The variation data
                            $variation_data =  array(
                                'attributes' => array(
                                    'size'  => str_replace(",","",$response->variations[$j]->values[$k]->value)
                                ),
                                'sku'           => '',
                                'regular_price' => $response_var->retailPrice,
                                'sale_price'    => $response_var->price,
                                'stock_qty'     => '',
                                'var_desc'      => $response->variations[$j]->values[$k]->asin,
                            );

                            // The function to be run
                            create_product_variation( $prod_id, $variation_data );

                            // $images_arr = $response_var->imageUrlList;
                            // add_images_to_woo_products($prod_id, download_images_by_url_arr($images_arr));
                        }
                    }
                }
            }

        }
}

function execute_curl($prodASIN){

    $prod_url = "https://www.amazon.in/dp/".$prodASIN;
    echo "prodASIN : ".$prod_url."</br>";

    $curl = curl_init();
    curl_setopt_array($curl, [
        // CURLOPT_URL => 'http://stageversion.com/api/api-res.json',
        CURLOPT_URL => 'https://axesso-axesso-amazon-data-service-v1.p.rapidapi.com/amz/amazon-lookup-product?url=' . $prod_url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "GET",
        CURLOPT_HTTPHEADER => [
            "X-RapidAPI-Host: axesso-axesso-amazon-data-service-v1.p.rapidapi.com",
            "X-RapidAPI-Key: fb3aa6b701msh6dfd54b56a72f02p192c8fjsnb420c2314bae"
        ],
    ]);
    $response = curl_exec($curl);
    $err = curl_error($curl);
    curl_close($curl);
    if ($err) {
        // echo "cURL Error #:" . $err;
    } else {
        return $response;
    }
}

function create_product_variation( $product_id, $variation_data ){

    print_r($variation_data);
    echo "</br>";

    // Get the Variable product object (parent)
    $product = wc_get_product($product_id);

    $variation_post = array(
        'post_title'  => $product->get_name(),
        'post_name'   => 'product-'.$product_id.'-variation',
        'post_status' => 'publish',
        'post_parent' => $product_id,
        'post_type'   => 'product_variation',
        'guid'        => $product->get_permalink()
    );

    // Creating the product variation
    $variation_id = wp_insert_post( $variation_post );

    // Get an instance of the WC_Product_Variation object
    $variation = new WC_Product_Variation( $variation_id );



    $product_attributes_data = array('pa_size' =>
        array(
            'name'         => 'pa_size',
            'position'     => '1',
            'is_visible'   => '1',
            'is_variation' => '1',
            'is_taxonomy'  => '1',
        )
    );

    update_post_meta($product_id, '_product_attributes', $product_attributes_data);


    // Iterating through the variations attributes
    foreach ($variation_data['attributes'] as $attribute => $term_name )
    {
        $taxonomy = 'pa_'.$attribute; // The attribute taxonomy

        // If taxonomy doesn't exists we create it (Thanks to Carl F. Corneil)
        if( ! taxonomy_exists( $taxonomy ) ){
            register_taxonomy(
                $taxonomy,
               'product_variation',
                array(
                    'hierarchical' => false,
                    'label' => ucfirst( $attribute ),
                    'query_var' => true,
                    'rewrite' => array( 'slug' => sanitize_title($attribute) ), // The base slug
                )
            );
        }

        // Check if the Term name exist and if not we create it.
        if( ! term_exists( $term_name, $taxonomy ) ){
            wp_insert_term( $term_name, $taxonomy ); // Create the term
        }

        $term_slug = get_term_by('name', $term_name, $taxonomy )->slug; // Get the term slug

        // Get the post Terms names from the parent variable product.
        $post_term_names =  wp_get_post_terms( $product_id, $taxonomy, array('fields' => 'names') );

        // Check if the post term exist and if not we set it in the parent variable product.
        if( ! in_array( $term_name, $post_term_names ) ){
            wp_set_post_terms( $product_id, $term_name, $taxonomy, true );
        }

        // Set/save the attribute data in the product variation
        update_post_meta( $variation_id, 'attribute_'.$taxonomy, $term_slug );
    }

    ## Set/save all other data

    // SKU
    if( $variation_data['sku'] != '' )
        $variation->set_sku( $variation_data['sku'] );
    else
        $variation->set_sku('');

    // Prices
    if( $variation_data['sale_price'] == '' ){
        $variation->set_price( $variation_data['regular_price'] );
    } else {
        $variation->set_price( $variation_data['sale_price'] );
        $variation->set_sale_price( $variation_data['sale_price'] );
    }
    $variation->set_regular_price( $variation_data['regular_price'] );

    // Stock
    if( $variation_data['stock_qty'] != '' ){
        $variation->set_stock_quantity( $variation_data['stock_qty'] );
        $variation->set_manage_stock(true);
        $variation->set_stock_status('');
    } else {
        $variation->set_manage_stock(false);
    }

    $variation->set_weight(''); // weight (reseting)
    $variation->set_description($variation_data['var_desc']);

    $variation->save(); // Save the data
}






function add_images_to_woo_products($product_id, $image_id_array){
    //take the first image in the array and set that as the featured image
    if (set_post_thumbnail($product_id, $image_id_array[0])) {
        echo $product_id . '<br />';
    } else {
        echo '<p>failed for product' . $prod_id . '</p>';
    }

    //if there is more than 1 image - add the rest to product gallery
    if(sizeof($image_id_array) > 1) {
        array_shift($image_id_array); //removes first item of the array (because it's been set as the featured image already)
        update_post_meta($product_id, '_product_image_gallery', implode(',',$image_id_array)); //set the images id's left over after the array shift as the gallery images
    }
}


function download_images_by_url_arr($images_url_arr){
    $attach_ids = array();
    foreach ($images_url_arr as $url) {
        // these are required for using media_handle_sideload()
        require_once(ABSPATH . 'wp-admin/includes/image.php');
        require_once(ABSPATH . 'wp-admin/includes/file.php');
        require_once(ABSPATH . 'wp-admin/includes/media.php');
        // temporary path of image
        $tmp_file = download_url( $url );
        // check if no error in download url
        if(!is_wp_error($tmp_file)){
            $file_array = array(
                'name' => basename($url),
                'tmp_name' => $tmp_file,
            );
            $attach_id = media_handle_sideload( $file_array );
            if ( !is_wp_error($attach_id) ) {
                $attach_ids[] = $attach_id;
            } else {
                echo '<p>error with attact id';
                var_dump($attach_id->get_error_message());
                var_dump($attach_id);
                echo '</p>';
            }
        } else {
            echo '<p>error with download_url:';
            var_dump($url);
            echo '</p>';
        }
        // make sure to delete temporary file
        @unlink( $tmp_file );
    }
    return $attach_ids;
}


function get_images_from_url($prod_id, $prod_url){
    $curl = curl_init();
    curl_setopt_array($curl, [
        // CURLOPT_URL => 'http://stageversion.com/api/api-res.json',
        CURLOPT_URL => 'https://axesso-axesso-amazon-data-service-v1.p.rapidapi.com/amz/amazon-lookup-product?url=' . $prod_url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "GET",
        CURLOPT_HTTPHEADER => [
            "X-RapidAPI-Host: axesso-axesso-amazon-data-service-v1.p.rapidapi.com",
            "X-RapidAPI-Key: fb3aa6b701msh6dfd54b56a72f02p192c8fjsnb420c2314bae"
        ],
    ]);
    $response = curl_exec($curl);
    $err = curl_error($curl);
    curl_close($curl);
    if ($err) {
        echo "cURL Error #:" . $err;
    } else {
        // decode in json to use like an object with arrows
        $response = json_decode($response);
        $images_arr = $response->imageUrlList;

        // combine all images, main image at start
        // main image is already in array, so commented code below
        // array_unshift($images_arr, $response->mainImage->imageUrl);
        add_images_to_woo_products($prod_id, download_images_by_url_arr($images_arr));
    }
}


// product import end



# NeoVim


This repository contains my config files for neovim. This readme contains some commands which I use.

## General
gx  open link in browser


" general commands
" :help vimrc-intro   opens vim configuration help manual
" :edit $MYVIMRC      edit the vim configuration file, can also use lowercase
" :edit $myvimrc
"

# NeoVim

## Keyboard Shortcuts

| Keys | Navigating |
| :--- | ---: |
| `h j k l` | left down up right |
| `<C-U>` / `<C-D>` | half page up/down |
| `b` / `w`  | previous/next word |
| `ge` / `e` | previous/next end of word |
| `0` (zero) | start of line |
| `^` | start of line after whitespace |
| `$` | end of line |
| `f` `c` | go forward to character `c` |
| `F` `c` | go backward to character `c` |
| `gg` | start of file |
| `G` | end of file |
| `:n` | goto line `n` |
| `nG` | goto line `n` |
| `zz` | center this line |
| `zt` | top this line |
| `zb` | bottom this line |

| Keys | Editing |
| :--- | ---: |
| `a` | append |
| `A` | append from end of line |
| `i` | insert |
| `o` | open next line |
| `O` | open previous line |
| `s` | substitue character |
| `S` | substitue line |
| `C` | delete until end of line and insert |
| `r` | replace character |
| `R` | replace mode |
| `u` | undo changes |
| `<C-r>` | redo changes |




### Resources

1. [Devhints Vim Cheatsheet](https://devhints.io/vim)





### Notes

Sublime Text Path
"C:\Program Files\Sublime Text\sublime_text.exe"








