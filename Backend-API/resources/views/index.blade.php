{{-- Show lading page --}}

@extends('vendor.landingpage.layouts.default')

@section('css')
    @parent
@endsection

@section('content')
    <div class="body_wrapper">
        <div id="preloader">
            <div id="ctn-preloader" class="ctn-preloader">
                <div class="animation-preloader">
                    <div class="spinner"></div>
                    <div class="txt-loading">
                        <span data-text-preloader="D" class="letters-loading">
                            D
                        </span>
                        <span data-text-preloader="o" class="letters-loading">
                            o
                        </span>
                        <span data-text-preloader="c" class="letters-loading">
                            c
                        </span>
                        <span data-text-preloader="t" class="letters-loading">
                            t
                        </span>
                        <span data-text-preloader="o" class="letters-loading">
                            o
                        </span>
                        <span data-text-preloader="w" class="letters-loading">
                            W
                        </span>
                        <span data-text-preloader="o" class="letters-loading">
                            o
                        </span>
                        <span data-text-preloader="r" class="letters-loading">
                            r
                        </span>
                        <span data-text-preloader="l" class="letters-loading">
                            l
                        </span>
                        <span data-text-preloader="d" class="letters-loading">
                            d
                        </span>
                    </div>
                    <p class="text-center">Loading</p>
                </div>
                <div class="loader">
                    <div class="row">
                        <div class="col-3 loader-section section-left">
                            <div class="bg"></div>
                        </div>
                        <div class="col-3 loader-section section-left">
                            <div class="bg"></div>
                        </div>
                        <div class="col-3 loader-section section-right">
                            <div class="bg"></div>
                        </div>
                        <div class="col-3 loader-section section-right">
                            <div class="bg"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <header class="header_area">
            <nav class="navbar navbar-expand-lg menu_seven">
                <div class="container">
                    <a class="navbar-brand sticky_logo" href="#">
                        <img src="img/logo2.png" srcset="img/logo2.png" alt="logo">
                        <img src="img/logo.png" srcset="img/logo.png" alt=""></a>

                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav menu pl_120 ml-auto">
                            <li class="nav-item dropdown submenu mega_menu mega_menu_two">
                                <a class="nav-link" role="button">
                                    &nbsp;
                                </a>
                            </li>


                        </ul>

                    </div>
                </div>
            </nav>
        </header>
        <section class="app_banner_area">
            <div class="container">
                <div class="row">
                    <div class="col-lg-7">
                        <div class="app_banner_contentmt mt_40">
                            <h2 class="f_p f_600 f_size_50 w_color mb_20 wow fadeInLeft" data-wow-delay="0.2s">All in
                                one
                                App for <br>Medicine & Doctors</h2>
                            <p class="f_400 f_size_18 l_height30 w_color wow fadeInLeft" data-wow-delay="0.3s">
                                Bender cobblers chap grub sloshed up duff I<br> fantastic owt to do with me at public
                                school.</p>
                            <a href="#download_app" class="btn_hover mt_30 app_btn wow fadeInLeft"
                                data-wow-delay="0.5s">Download Now</a>
                        </div>
                    </div>
                    <div class="col-lg-5">
                        <div class="app_img">
                            <img class="mobile  wow fadeInDown" src="img/app.png" alt="">
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="app_featured_area" id="services">
            <div class="container">
                <div class="row flex-row-reverse app_feature_info">
                    <div class="col-lg-6">
                        <div class="app_fetured_item">
                            <div class="app_item item_one" data-parallax='{"x": 0, "y": 50}'>

                                <img class="" src="img/ic_appliances.png">
                                <h6 class="f_p f_400 f_size_16 w_color l_height45">Book Appointment</h6>
                            </div>
                            <div class="app_item item_two" data-parallax='{"x": 0, "y": -30}'>

                                <img class="" src="img/ic_homecare.png">
                                <h6 class="f_p f_400 f_size_16 w_color l_height45">Hosptails</h6>
                            </div>
                            <div class="app_item item_three" data-parallax='{"x": 50, "y": 10}'>

                                <img class="" src="img/ic_beauty.png">
                                <h6 class="f_p f_400 f_size_16 w_color l_height45">Buy Medicine</h6>
                            </div>
                            <div class="app_item item_four" data-parallax='{"x": -20, "y": 50}'>

                                <img class="" src="img/ic_computer.png">
                                <h6 class="f_p f_400 f_size_16 w_color l_height45">Pill Reminder</h6>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="app_featured_content">
                            <h2 class="f_p f_size_30 f_700 t_color3 l_height45 pr_70 mb-30">List of services you are
                                <br>looking for...
                            </h2>
                            <p class="f_400">You can book a wide range of services, delivered by well qualified
                                professionals from anywhere, anytime. Search from a list of services and book a desired
                                service.</p>
                            <a href="#" class="learn_btn_two">&nbsp;</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="app_featured_area_two">
            <div class="triangle_shape"></div>
            <div class="container">
                <div class="row app_feature_info">
                    <div class="col-lg-5">
                        <div class="app_img">

                            <img class="text_bg one wow fadeInLeft" data-wow-delay="0.1s" src="img/text_one.png" alt="">
                            <img class="text_bg two wow fadeInDown" data-wow-delay="0.1s" src="img/text_three.png" alt="">
                            <img class="text_bg three wow fadeInRight" data-wow-delay="0.1s" src="img/text_two.png" alt="">
                            <img class="wow fadeIn phone_img" src="img/iPhonex.png" alt="">
                        </div>
                    </div>
                    <div class="col-lg-7 d-flex align-items-center">
                        <div class="app_featured_content">
                            <h2 class="f_p f_size_30 f_700 t_color3 l_height45 mb-30">Get medicine delivered <br>Right
                                at
                                your doorstep</h2>
                            <p class="f_400"> Pick your location at which you require a service, select the desired
                                category
                                and sub-category for a service you are looking for and book for the nearby available
                                service
                                providers. </p>

                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="app_service_area" id="features">
            <div class="container">
                <div class="sec_title text-center mb_70">
                    <h2 class="f_p f_size_30 l_height30 f_700 t_color3 mb_20 wow fadeInUp">App Features</h2>
                    <p class="f_400 f_size_16 wow fadeInUp" data-wow-delay="0.2s">Bender cobblers chap gruap sloshed up
                        the
                        duff | fantasitic owt to<br> do with me at public school, James Bond chip shop chancer.</p>
                </div>
                <div class="row app_service_info">
                    <div class="col-lg-4">
                        <div class="app_service_item wow fadeInUp" data-wow-delay="0.2s">

                            <img src="img/Features1.png" class="app_icon one">
                            <h5 class="f_p f_size_18 f_600 t_color3 mt_40 mb-30">Verified Provider</h5>
                            <p class="f_400 f_size_15 mb-0"> Provider are verified with their Goverment Identification
                                before sending them to your homes.!</p>

                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="app_service_item wow fadeInUp" data-wow-delay="0.4s">
                            <!--                            <i class="ti-heart-broken app_icon two"></i>-->
                            <img src="img/Features2.png" class="app_icon one">
                            <h5 class="f_p f_size_18 f_600 t_color3 mt_40 mb-30">Allmost all Solution </h5>
                            <p class="f_400 f_size_15 mb-0"> Get almost all of the essential required services at your
                                doorstep in no time.</p>

                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="app_service_item wow fadeInUp" data-wow-delay="0.6s">
                            <!--                            <i class="ti-target app_icon three"></i>-->
                            <img src="img/Features3.png" class="app_icon one">
                            <h5 class="f_p f_size_18 f_600 t_color3 mt_40 mb-30">Appointment status</h5>
                            <p class="f_400 f_size_15 mb-0">Track you appoointment status and get notified for each
                                status
                                update.</p>

                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="app_service_item wow fadeInUp" data-wow-delay="0.6s">
                            <!--                            <i class="ti-target app_icon three"></i>-->
                            <img src="img/Features4.png" class="app_icon one">
                            <h5 class="f_p f_size_18 f_600 t_color3 mt_40 mb-30">Social Login</h5>
                            <p class="f_400 f_size_15 mb-0"> Get in the application with a single tap on social login
                                through variety of platforms.</p>

                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="app_service_item wow fadeInUp" data-wow-delay="0.2s">
                            <!--                            <i class="ti-settings app_icon one"></i>-->
                            <img src="img/Features5.png" class="app_icon one">
                            <h5 class="f_p f_size_18 f_600 t_color3 mt_40 mb-30">Chat with Provider</h5>
                            <p class="f_400 f_size_15 mb-0"> Wish to get in touch with provider, directly text him in
                                the
                                application itself. </p>

                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="app_service_item wow fadeInUp" data-wow-delay="0.6s">
                            <!--                            <i class="ti-target app_icon three"></i>-->
                            <img src="img/Features6.png" class="app_icon one">
                            <h5 class="f_p f_size_18 f_600 t_color3 mt_40 mb-30">Multi Language</h5>
                            <p class="f_400 f_size_15 mb-0">Get the app translated in the desired language from a list
                                of
                                available languages.</p>

                        </div>
                    </div>
                </div>
            </div>
        </section>


        <section class="app_screenshot_area sec_pad" id="screenshots">
            <div class="custom_container p0">

                <div class="sec_title text-center mb_70">
                    <h2 class="f_p f_size_30 l_height30 f_700 t_color3 mb_20 wow fadeInUp" data-wow-delay="0.2s">User
                        App
                        Screenshots</h2>
                    <p class="f_400 f_size_16 wow fadeInUp" data-wow-delay="0.4s">Bender cobblers chap gruap sloshed up
                        the
                        duff | fantasitic owt to<br> do with me at public school, James Bond chip shop chancer.</p>
                </div>
                <div class="app_screen_info">
                    <div class="app_screenshot_slider owl-carousel">
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot1.png" class="image-link">
                                    <img src="img/screenshot1.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot2.png" class="image-link">
                                    <img src="img/screenshot2.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot3.png" class="image-link">
                                    <img src="img/screenshot3.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot4.png" class="image-link">
                                    <img src="img/screenshot4.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot5.png" class="image-link">
                                    <img src="img/screenshot5.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot6.png" class="image-link">
                                    <img src="img/screenshot6.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot1.png" class="image-link">
                                    <img src="img/screenshot1.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot2.png" class="image-link">
                                    <img src="img/screenshot2.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot3.png" class="image-link">
                                    <img src="img/screenshot3.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot4.png" class="image-link">
                                    <img src="img/screenshot4.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot5.png" class="image-link">
                                    <img src="img/screenshot5.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="item">
                            <div class="screenshot_img">
                                <a href="img/screenshot6.png" class="image-link">
                                    <img src="img/screenshot6.png" alt="">
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="get_started_area" id="download_app">
            <!--
                                                        <div class="shap one"></div>
                                                        <div class="shap two"></div>
                                                        <div class="shap one three"></div>
                                                        <div class="shap two four"></div>
                                                -->
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 d-flex align-items-center">
                        <div class="get_content">
                            <h3 class="f_500 f_size_30  f_p wow fadeInLeft" style="letter-spacing: 2px;"
                                data-wow-delay="0.2s">{{ config('app.name') }}</h3>
                            <h2 class="f_700 f_p f_size_40 l_height50 mb_20 wow fadeInLeft" data-wow-delay="0.3s">
                                Download
                                User App Now</h2>
                            <p class="f_400 f_p mb_40 wow fadeInLeft" data-wow-delay="0.4s">Bender cobblers chap gruap
                                sloshed up the duff | fantasitic owt to<br> do with me at public school, James Bond chip
                                shop chancer. <br>my lady gormless brillic the full monty lavatory.</p>
                            <a href="{{ config('app.landing_google_link', '#') }}"
                                class="app_btn app_btn_one wow fadeInLeft" data-wow-delay="0.5s" target="_blank"><img
                                    src="img/home7/google_icon.png" alt="">Google Play</a>
                            <a href="{{ config('app.landing_google_link', '#') }}"
                                class="app_btn app_btn_two wow fadeInLeft" data-wow-delay="0.6s"><i
                                    class="fab fa-apple"></i>Apple Store</a>
                        </div>
                    </div>

                </div>
            </div>
        </section>


        <footer class="footer_area footer_seven f_bg" id="contact">
            <div class="footer_top">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-4 col-sm-6">
                            <div class="f_widget company_widget wow fadeInLeft" data-wow-delay="0.2s">
                                <a href="#" class="f-logo"><img src="img/logo.png" alt=""></a>
                            </div>
                        </div>

                        <div class="col-lg-4 col-sm-6">
                            <div class="f_widget company_widget wow fadeInLeft" data-wow-delay="0.2s">
                                <div class="f_social_icon">
                                    {{-- <a href="#"><i class="fab fa-facebook-f"></i></a>
                                    <a href="#"><i class="fab fa-twitter"></i></a>
                                    <a href="#"><i class="fab fa-vimeo-v"></i></a>
                                    <a href="#"><i class="fab fa-pinterest-p"></i></a> --}}
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4 col-sm-6">
                            <div class="f_widget company_widget wow fadeInLeft" data-wow-delay="0.2s">
                                <div class="widget-wrap mt-0">
                                    @if (config('app.landing_email'))
                                        <p class="f_500 f_p f_size_15 mb-0 l_height34">
                                            <span>Email: &nbsp;</span><a href="#"
                                                class="f_500">{{ config('app.landing_email') }}</a>
                                        </p>
                                    @endif

                                    @if (config('app.landing_phone'))
                                        <p class="f_500 f_p f_size_15 mb-0 l_height34">
                                            <span>Phone:</span><a href="#"
                                                class="f_500">{{ config('app.landing_phone') }}</a>
                                        </p>
                                    @endif
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </div>

@endsection

@section('js')
    @parent
@endsection
