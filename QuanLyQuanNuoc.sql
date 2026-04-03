CREATE DATABASE QuanLyQuanNuoc_Test6
GO

USE QuanLyQuanNuoc_Test6
GO

-- 1. Các bảng loại
CREATE TABLE LoaiNguyenLieu(
    maLoaiNguyenLieu INT IDENTITY(1,1) PRIMARY KEY,
    tenLoaiNguyenLieu NVARCHAR(100) NOT NULL
)
GO

CREATE TABLE LoaiDoUong(
    maLoai INT IDENTITY(1,1) PRIMARY KEY,
    tenLoai NVARCHAR(100) NOT NULL
)
GO

-- 2. Người dùng
CREATE TABLE NguoiDung(
    maNguoiDung INT IDENTITY(1,1) PRIMARY KEY,
    tenNguoiDung NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    tenDangNhap NVARCHAR(50) NOT NULL,
    matKhau NVARCHAR(255) NOT NULL,
    vaiTro NVARCHAR(50) NOT NULL,
    trangThai BIT NOT NULL,
    hinhAnh NVARCHAR(255)
)
GO

-- 3. Nhà cung cấp
CREATE TABLE NhaCungCap(
    maNCC INT IDENTITY(1,1) PRIMARY KEY,
    tenNCC NVARCHAR(100) NOT NULL,
    dienThoai NVARCHAR(20),
    diaChi NVARCHAR(255)
)
GO

-- 4. Nguyên liệu
CREATE TABLE NguyenLieu(
    maNguyenLieu INT IDENTITY(1,1) PRIMARY KEY,
    maLoaiNguyenLieu INT NOT NULL,
    tenNguyenLieu NVARCHAR(100) NOT NULL,
    soLuongTon INT NOT NULL,
    donvi NVARCHAR(50) NOT NULL,
    soLuongToiThieu INT,
    ghiChu NVARCHAR(255),
    CONSTRAINT FK_NguyenLieu_LoaiNguyenLieu FOREIGN KEY (maLoaiNguyenLieu) REFERENCES LoaiNguyenLieu(maLoaiNguyenLieu)
)
GO

-- 5. CÔNG THỨC (Đã thêm trangThai trực tiếp vào đây)
CREATE TABLE CongThuc(
    maCongThuc INT IDENTITY(1,1) PRIMARY KEY,
    tenCongThuc NVARCHAR(100) NOT NULL,
    trangThai BIT NOT NULL DEFAULT 1 -- 1 là đang dùng, 0 là ẩn
)
GO

-- 6. Chi tiết công thức
CREATE TABLE CongThucChiTiet(
    maCongThucCT INT IDENTITY(1,1) PRIMARY KEY,
    maCongThuc INT NOT NULL,
    maNguyenLieu INT NOT NULL,
    dinhLuong INT NOT NULL,
    CONSTRAINT FK_CTCT_CongThuc FOREIGN KEY (maCongThuc) REFERENCES CongThuc(maCongThuc),
    CONSTRAINT FK_CTCT_NguyenLieu FOREIGN KEY (maNguyenLieu) REFERENCES NguyenLieu(maNguyenLieu)
)
GO

-- 7. Đồ uống
CREATE TABLE DoUong(
    maDoUong INT IDENTITY(1,1) PRIMARY KEY,
    maLoai INT NOT NULL,
    maCongThuc INT NOT NULL,
    tenDoUong NVARCHAR(100) NOT NULL,
    giaTien DECIMAL(10,2) NOT NULL,
    giaVon DECIMAL(10,2),
    moTa NVARCHAR(255),
    hinhAnh NVARCHAR(255),
    khuyenMai DECIMAL(5,2),
    trangThai BIT NOT NULL,
    CONSTRAINT FK_DoUong_Loai FOREIGN KEY (maLoai) REFERENCES LoaiDoUong(maLoai),
    CONSTRAINT FK_DoUong_CongThuc FOREIGN KEY (maCongThuc) REFERENCES CongThuc(maCongThuc)
)
GO

-- 8. Hóa đơn
CREATE TABLE HoaDon(
    maHoaDon INT IDENTITY(1,1) PRIMARY KEY,
    maNguoiDung INT NOT NULL,
    trangThai BIT NOT NULL,
    tongTien DECIMAL(10,2) NOT NULL,
    ngayTao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_HoaDon_NguoiDung FOREIGN KEY (maNguoiDung) REFERENCES NguoiDung(maNguoiDung)
)
GO

-- 9. Chi tiết hóa đơn
CREATE TABLE HoaDonChiTiet(
    maHDCT INT IDENTITY(1,1) PRIMARY KEY,
    maHoaDon INT NOT NULL,
    maDoUong INT NOT NULL,
    donGia DECIMAL(10,2) NOT NULL,
    soLuong INT NOT NULL,
    CONSTRAINT FK_HDCT_HoaDon FOREIGN KEY (maHoaDon) REFERENCES HoaDon(maHoaDon),
    CONSTRAINT FK_HDCT_DoUong FOREIGN KEY (maDoUong) REFERENCES DoUong(maDoUong)
)
GO

-- 10. Nhập kho
CREATE TABLE PhieuNhapKho(
    maPhieuNhapKho INT IDENTITY(1,1) PRIMARY KEY,
    maNguoiDung INT NOT NULL,
    maNCC INT NOT NULL,
    ngayNhapKho DATETIME DEFAULT GETDATE(),
    tongTien DECIMAL(10,2),
    ghiChu NVARCHAR(255),
    CONSTRAINT FK_PNK_NguoiDung FOREIGN KEY (maNguoiDung) REFERENCES NguoiDung(maNguoiDung),
    CONSTRAINT FK_PNK_NCC FOREIGN KEY (maNCC) REFERENCES NhaCungCap(maNCC)
)
GO

CREATE TABLE PhieuNhapKhoChiTiet(
    maPhieuNKCT INT IDENTITY(1,1) PRIMARY KEY,
    maPhieuNhapKho INT NOT NULL,
    maNguyenLieu INT NOT NULL,
    soLuong INT NOT NULL,
    ngayHetHan DATE,
    donGiaNhap DECIMAL(10,2),
    CONSTRAINT FK_PNKCT_PNK FOREIGN KEY (maPhieuNhapKho) REFERENCES PhieuNhapKho(maPhieuNhapKho),
    CONSTRAINT FK_PNKCT_NL FOREIGN KEY (maNguyenLieu) REFERENCES NguyenLieu(maNguyenLieu)
)
GO

-- =============================================
-- PHẦN INSERT DỮ LIỆU
-- =============================================

INSERT INTO NguoiDung(tenNguoiDung, email, tenDangNhap, matKhau, vaiTro, trangThai, hinhAnh)
VALUES
(N'Admin', 'admin@gmail.com', 'admin', '123', 'ADMIN', 1, NULL),
(N'Nhân viên 1', 'nv1@gmail.com', 'nv1', '123', 'STAFF', 1, NULL),
(N'Nhân viên 2', 'nv2@gmail.com', 'nv2', '123', 'STAFF', 1, NULL)
GO

INSERT INTO LoaiNguyenLieu(tenLoaiNguyenLieu) VALUES (N'Trà'), (N'Cà phê'), (N'Sữa'), (N'Trái cây'), (N'Syrup'), (N'Khác')
GO

INSERT INTO NhaCungCap(tenNCC, dienThoai, diaChi)
VALUES
(N'Nhà cung cấp A', '0900000001', N'HCM'),
(N'Nhà cung cấp B', '0900000002', N'Hà Nội'),
(N'Nhà cung cấp C', '0900000003', N'Đà Nẵng')
GO

INSERT INTO NguyenLieu(maLoaiNguyenLieu, tenNguyenLieu, soLuongTon, donvi, soLuongToiThieu)
VALUES
(1, N'Trà xanh', 1000, N'ml', 100),
(2, N'Cà phê rang', 500, N'g', 50),
(3, N'Sữa tươi', 300, N'ml', 50),
(4, N'Cam', 200, N'quả', 20),
(5, N'Syrup dâu', 150, N'ml', 20),
(6, N'Đường', 1000, N'g', 100)
GO

-- Insert Công thức kèm trạng thái
INSERT INTO CongThuc(tenCongThuc, trangThai)
VALUES
(N'Trà sữa cơ bản', 1),
(N'Cà phê sữa', 1),
(N'Nước cam', 1),
(N'Trà trái cây', 1),
(N'Sinh tố', 1),
(N'Trà đào', 1)
GO

INSERT INTO CongThucChiTiet(maCongThuc, maNguyenLieu, dinhLuong)
VALUES
(1,1,100),(1,3,50),
(2,2,50),(2,3,30),
(3,4,2),
(4,1,80),(4,5,20),
(5,4,3),(5,3,50),
(6,1,100),(6,5,30)
GO

INSERT INTO LoaiDoUong(tenLoai)
VALUES (N'Trà sữa'), (N'Cà phê'), (N'Nước ép'), (N'Trà trái cây'), (N'Sinh tố'), (N'Trà nóng')
GO

-- Nhóm 1: Trà sữa (maLoai = 1, maCongThuc = 1)
INSERT INTO DoUong(maLoai, maCongThuc, tenDoUong, giaTien, giaVon, moTa, hinhAnh, khuyenMai, trangThai) VALUES
(1, 1, N'Trà sữa Trân châu đường đen', 35000, 15000, N'Vị ngọt thanh, trân châu dai giòn', NULL, 0, 1),
(1, 1, N'Trà sữa Matcha', 38000, 16000, N'Bột matcha Nhật Bản nguyên chất', NULL, 5, 1),
(1, 1, N'Trà sữa Khoai môn', 35000, 15000, N'Thơm mùi khoai môn đặc trưng', NULL, 0, 1),
(1, 1, N'Trà sữa Socola', 35000, 15000, N'Đậm đà vị socola nguyên chất', NULL, 0, 1),
(1, 1, N'Trà sữa Thái xanh', 30000, 12000, N'Trà Thái thơm mát', NULL, 0, 1),
(1, 1, N'Trà sữa Thái đỏ', 30000, 12000, N'Hương vị trà Thái truyền thống', NULL, 0, 1),
(1, 1, N'Trà sữa Hạt dẻ', 40000, 18000, N'Bùi bùi vị hạt dẻ', NULL, 0, 1),
(1, 1, N'Trà sữa Kem nướng', 45000, 20000, N'Lớp kem cháy thơm lừng', NULL, 0, 1),

-- Nhóm 2: Cà phê (maLoai = 2, maCongThuc = 2)
(2, 2, N'Cà phê Đen đá', 20000, 7000, N'Cà phê rang xay nguyên chất', NULL, 0, 1),
(2, 2, N'Cà phê Sữa đá', 25000, 9000, N'Sữa đặc hòa quyện cà phê', NULL, 0, 1),
(2, 2, N'Bạc xỉu', 28000, 10000, N'Nhiều sữa ít cà phê', NULL, 0, 1),
(2, 2, N'Cà phê Muối', 32000, 12000, N'Hot trend vị mặn ngọt hài hòa', NULL, 0, 1),
(2, 2, N'Cà phê Trứng', 40000, 15000, N'Lớp kem trứng béo ngậy', NULL, 0, 1),
(2, 2, N'Cà phê Cốt dừa', 35000, 14000, N'Thơm mùi dừa xay', NULL, 0, 1),
(2, 2, N'Latte Macchiato', 45000, 18000, N'Cà phê Ý nhẹ nhàng', NULL, 0, 1),
(2, 2, N'Cappuccino', 45000, 18000, N'Lớp bọt mịn màng', NULL, 0, 1),
(2, 2, N'Americano', 30000, 8000, N'Cà phê đen pha loãng', NULL, 0, 1),

-- Nhóm 3: Nước ép (maLoai = 3, maCongThuc = 3)
(3, 3, N'Nước cam vắt', 30000, 12000, N'Cam tươi nguyên chất', NULL, 0, 1),
(3, 3, N'Nước ép Thơm (Dứa)', 30000, 10000, N'Giải nhiệt mùa hè', NULL, 0, 1),
(3, 3, N'Nước ép Dưa hấu', 25000, 8000, N'Ngọt mát tự nhiên', NULL, 0, 1),
(3, 3, N'Nước ép Cà rốt', 30000, 10000, N'Tốt cho sức khỏe', NULL, 0, 1),
(3, 3, N'Nước ép Táo', 35000, 15000, N'Táo đỏ nhập khẩu', NULL, 0, 1),
(3, 3, N'Nước ép Ổi', 25000, 8000, N'Giàu vitamin C', NULL, 0, 1),
(3, 3, N'Nước chanh tươi', 20000, 5000, N'Chanh đường truyền thống', NULL, 0, 1),
(3, 3, N'Nước chanh leo', 25000, 7000, N'Vị chua thanh mát', NULL, 0, 1),

-- Nhóm 4: Trà trái cây (maLoai = 4, maCongThuc = 4)
(4, 4, N'Trà vải', 35000, 12000, N'Trà đen kết hợp vải thiều', NULL, 0, 1),
(4, 4, N'Trà nhãn', 35000, 12000, N'Vị ngọt của nhãn lồng', NULL, 0, 1),
(4, 4, N'Trà dâu tây', 38000, 15000, N'Dâu tây Đà Lạt tươi', NULL, 5, 1),
(4, 4, N'Trà sen vàng', 45000, 20000, N'Trà ô long và hạt sen', NULL, 0, 1),
(4, 4, N'Trà thạch đào', 35000, 12000, N'Miếng đào giòn tan', NULL, 0, 1),
(4, 4, N'Trà hoa cúc', 30000, 10000, N'Thanh lọc cơ thể', NULL, 0, 1),
(4, 4, N'Trà thanh long', 35000, 12000, N'Màu sắc bắt mắt tự nhiên', NULL, 0, 1),
(4, 4, N'Trà trái cây nhiệt đới', 45000, 18000, N'Tổng hợp nhiều loại trái cây', NULL, 0, 1),

-- Nhóm 5: Sinh tố (maLoai = 5, maCongThuc = 5)
(5, 5, N'Sinh tố Bơ', 45000, 20000, N'Bơ sáp béo ngậy', NULL, 0, 1),
(5, 5, N'Sinh tố Xoài', 40000, 15000, N'Xoài cát hòa lộc', NULL, 0, 1),
(5, 5, N'Sinh tố Mãng cầu', 40000, 15000, N'Vị chua ngọt đặc trưng', NULL, 0, 1),
(5, 5, N'Sinh tố Việt quất', 50000, 25000, N'Việt quất nhập khẩu', NULL, 0, 1),
(5, 5, N'Sinh tố Sapoche', 35000, 14000, N'Hương vị quê hương', NULL, 0, 1),
(5, 5, N'Sinh tố Chuối', 30000, 10000, N'Tốt cho người tập gym', NULL, 0, 1),
(5, 5, N'Sinh tố Dâu', 45000, 18000, N'Dâu tươi xay mịn', NULL, 0, 1),
(5, 5, N'Sinh tố Chanh tuyết', 30000, 10000, N'Mát lạnh sảng khoái', NULL, 0, 1),

-- Nhóm 6: Trà nóng/Khác (maLoai = 6, maCongThuc = 6)
(6, 6, N'Trà Đào Cam Sả', 39000, 15000, N'Thức uống quốc dân', NULL, 0, 1),
(6, 6, N'Trà gừng mật ong', 25000, 8000, N'Ấm bụng ngày mưa', NULL, 0, 1),
(6, 6, N'Trà Atiso', 30000, 10000, N'Tốt cho gan', NULL, 0, 1),
(6, 6, N'Cacao nóng', 30000, 12000, N'Vị đắng nhẹ, thơm nồng', NULL, 0, 1),
(6, 6, N'Trà Oolong', 25000, 8000, N'Hương thơm thanh khiết', NULL, 0, 1),
(6, 6, N'Sữa tươi trân châu', 35000, 15000, N'Đường đen thơm phức', NULL, 0, 1),
(6, 6, N'Trà xanh lài', 25000, 7000, N'Hương nhài dịu nhẹ', NULL, 0, 1),
(6, 6, N'Trà hoa đậu biếc', 35000, 12000, N'Màu tím mộng mơ', NULL, 0, 1),
(6, 6, N'Soda Blue Ocean', 30000, 10000, N'Sảng khoái đại dương', NULL, 0, 1),
(6, 6, N'Yogurt trái cây', 40000, 18000, N'Sữa chua nhà làm', NULL, 0, 1);
GO

INSERT INTO HoaDon(maNguoiDung, trangThai, tongTien)
VALUES (1,1,50000), (2,1,80000), (3,1,120000)
GO

INSERT INTO HoaDonChiTiet(maHoaDon, maDoUong, donGia, soLuong)
VALUES (1,1,20000,2), (2,5,30000,2), (3,10,40000,3)
GO

INSERT INTO PhieuNhapKho(maNguoiDung, maNCC, tongTien)
VALUES (1,1,500000), (2,2,300000)
GO

INSERT INTO PhieuNhapKhoChiTiet(maPhieuNhapKho, maNguyenLieu, soLuong, ngayHetHan, donGiaNhap)
VALUES (1,1,500,'2026-12-31',10000), (1,2,200,'2026-10-10',15000), (2,3,300,'2026-09-01',12000)
GO

