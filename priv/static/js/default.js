//disable Company record
$('#dt-company').on('click', '.js-sweetalert2-disable_company', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to enable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Companies/disable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Enable Company record
$('#dt-company').on('click', '.js-sweetalert2-enable_company', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to enable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Companies/enable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 1) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//disable Product record
$('#dt-product').on('click', '.js-sweetalert2-disable_product', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to disable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/products/disable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Enable Product record
$('#dt-product').on('click', '.js-sweetalert2-enable_product', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to enable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/products/enable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 1) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//disable Staff record
$('#dt-staff').on('click', '.js-sweetalert2-disable_staff', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to disable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/staff/disable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Enable Staff record
$('#dt-staff').on('click', '.js-sweetalert2-enable_staff', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to enable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/staff/enable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 1) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});