package controller;

import dao.HoaDonDAO;
import dao.HoaDonDAOImpl;
import dao.HoaDonChiTietDAO;
import dao.HoaDonChiTietDAOImpl;

import entity.HoaDon;
import entity.HoaDonChiTiet;
import entity.NguoiDung;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/hoadoncuatoi")
public class HoaDonCuaToiServlet extends HttpServlet {

    private HoaDonDAO hoaDonDAO = new HoaDonDAOImpl();
    private HoaDonChiTietDAO hdctDAO = new HoaDonChiTietDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        NguoiDung user = util.AuthUtil.getUser(request);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int maNguoiDung = user.getMaNguoiDung();

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        List<HoaDon> list;

        try {
            if (fromDate != null && toDate != null &&
                    !fromDate.isEmpty() && !toDate.isEmpty()) {

                Timestamp from = Timestamp.valueOf(fromDate + " 00:00:00");
                Timestamp to = Timestamp.valueOf(toDate + " 23:59:59");

                list = hoaDonDAO.selectByMaNguoiDung(maNguoiDung)
                        .stream()
                        .filter(hd -> !hd.getNgayTao().before(from)
                                && !hd.getNgayTao().after(to))
                        .collect(Collectors.toList());
            } else {
                list = hoaDonDAO.selectByMaNguoiDung(maNguoiDung);
            }
        } catch (Exception e) {
            e.printStackTrace();
            list = hoaDonDAO.selectByMaNguoiDung(maNguoiDung);
        }

        // ===== MAP =====
        Map<Integer, List<HoaDonChiTiet>> mapChiTiet = new HashMap<>();
        Map<Integer, Integer> mapSoMon = new HashMap<>();
        Map<Integer, String> mapTenDoUong = new HashMap<>();

        for (HoaDon hd : list) {
            try {
                List<HoaDonChiTiet> ctList =
                        hdctDAO.selectByHoaDonId(hd.getMaHoaDon());

                mapChiTiet.put(hd.getMaHoaDon(), ctList);

                int tongSoLuong = 0;

                for (HoaDonChiTiet ct : ctList) {

                    // lấy tên đồ uống
                    if (!mapTenDoUong.containsKey(ct.getMaDoUong())) {
                        String ten = hdctDAO.getTenDoUong(ct.getMaDoUong());
                        mapTenDoUong.put(ct.getMaDoUong(), ten);
                    }

                    tongSoLuong += ct.getSoLuong();
                }

                mapSoMon.put(hd.getMaHoaDon(), tongSoLuong);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        int tong = 0;
        for (HoaDon hd : list) {
            if (hd.isTrangThai()) {
                tong += hd.getTongTien();
            }
        }

        request.setAttribute("listHoaDon", list);
        request.setAttribute("mapChiTiet", mapChiTiet);
        request.setAttribute("mapSoMon", mapSoMon);
        request.setAttribute("mapTenDoUong", mapTenDoUong);
        request.setAttribute("tongDoanhThu", tong);
        request.setAttribute("soHoaDon", list.size());

        request.getRequestDispatcher("/hoadoncuatoi.jsp")
                .forward(request, response);
    }
}