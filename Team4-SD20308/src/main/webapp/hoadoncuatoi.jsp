<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn của tôi</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <style>
        body { background: #0f0f0f; color: white; }

        .card-dark {
            background: #1a1a1a;
            padding: 20px;
            border-radius: 12px;
        }

        .revenue-box {
            background: #1a1a1a;
            padding: 20px;
            border-radius: 12px;
        }

        .badge-paid { background: #198754; }
        .badge-wait { background: #ffc107; color: black; }
    </style>
</head>

<body>

<div class="container mt-4">

    <h3>📄 Hóa đơn của tôi</h3>

    <!-- FILTER -->
    <div class="row mb-4">

        <div class="col-md-8">
            <div class="card-dark">
                <form action="hoadoncuatoi">
                    <div class="row">
                        <div class="col-md-4">
                            <input type="date" name="fromDate"
                                   class="form-control"
                                   value="${param.fromDate}">
                        </div>
                        <div class="col-md-4">
                            <input type="date" name="toDate"
                                   class="form-control"
                                   value="${param.toDate}">
                        </div>
                        <div class="col-md-4">
                            <button class="btn btn-warning w-100">
                                Tìm kiếm
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-md-4">
            <div class="revenue-box">
                <h4>${tongDoanhThu} đ</h4>
                <div>${soHoaDon} hóa đơn</div>
            </div>
        </div>

    </div>

    <!-- TABLE -->
    <table class="table table-dark text-center">
        <thead>
        <tr>
            <th>Mã HD</th>
            <th>Thời gian</th>
            <th>Số món</th>
            <th>Tổng tiền</th>
            <th>Trạng thái</th>
            <th>Chi tiết</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="hd" items="${listHoaDon}">
            <tr>
                <td>HD${hd.maHoaDon}</td>

                <td>
                    <fmt:formatDate value="${hd.ngayTao}"
                                    pattern="dd/MM/yyyy HH:mm:ss"/>
                </td>

                <td>${mapSoMon[hd.maHoaDon]}</td>
                <td>${hd.tongTien} đ</td>

                <td>
                    <c:choose>
                        <c:when test="${hd.trangThai}">
                            <span class="badge badge-paid">Đã TT</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-wait">Chưa TT</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <td>
                    <button class="btn btn-sm btn-outline-light"
                            data-bs-toggle="modal"
                            data-bs-target="#modal${hd.maHoaDon}">
                        👁
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>

<!-- MODAL BILL -->
<c:forEach var="hd" items="${listHoaDon}">
    <div class="modal fade" id="modal${hd.maHoaDon}">
        <div class="modal-dialog modal-dialog-centered">

            <div class="modal-content p-4"
                 style="background:#fff;color:#000;border-radius:12px;max-width:420px;margin:auto">

                <!-- HEADER -->
                <h4 class="text-center mb-1">PolyCoffee</h4>
                <p class="text-center" style="font-size:12px;">
                    Hệ thống quản lý nhà hàng
                </p>
                <hr>

                <!-- INFO -->
                <div class="d-flex justify-content-between">
                    <span>Mã HĐ:</span>
                    <span>HD${hd.maHoaDon}</span>
                </div>

                <div class="d-flex justify-content-between">
                    <span>Thời gian:</span>
                    <span>
                        <fmt:formatDate value="${hd.ngayTao}"
                                        pattern="dd/MM/yyyy HH:mm:ss"/>
                    </span>
                </div>

                <hr>

                <!-- DANH SÁCH MÓN -->
                <c:set var="tong" value="0"/>

                <c:forEach var="ct" items="${mapChiTiet[hd.maHoaDon]}">

                    <c:set var="thanhTien" value="${ct.soLuong * ct.donGia}"/>
                    <c:set var="tong" value="${tong + thanhTien}"/>

                    <div class="d-flex justify-content-between">
                        <span>
                            ${mapTenDoUong[ct.maDoUong]} x${ct.soLuong}
                        </span>
                        <span>${thanhTien} đ</span>
                    </div>

                </c:forEach>

                <hr>

                <!-- TÍNH TIỀN -->
                <c:set var="vat" value="${tong * 0.08}"/>
                <c:set var="total" value="${tong + vat}"/>

                <div class="d-flex justify-content-between">
                    <span>Tạm tính:</span>
                    <span>${tong} đ</span>
                </div>

                <div class="d-flex justify-content-between">
                    <span>VAT (8%):</span>
                    <span>${Math.round(vat)} đ</span>
                </div>

                <div class="d-flex justify-content-between fw-bold">
                    <span>Tổng:</span>
                    <span>${Math.round(total)} đ</span>
                </div>

                <hr>

                <!-- TRẠNG THÁI -->
                <c:choose>
                    <c:when test="${hd.trangThai}">
                        <p class="text-center fw-bold text-success">
                            Đã thanh toán
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center fw-bold text-danger">
                            Chưa thanh toán
                        </p>
                    </c:otherwise>
                </c:choose>

                <p class="text-center">Cảm ơn quý khách!</p>

                <button class="btn btn-secondary w-100 mt-2"
                        data-bs-dismiss="modal">
                    Đóng
                </button>

            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>