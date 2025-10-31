Giải thích các thay đổi:
1) Bỏ extendBody: true (Dòng 40)
Trước: extendBody: true
Sau: không có
Lý do: extendBody khiến body kéo dài xuống bottom bar, dễ vỡ bố cục khi mở bàn phím.
2) Bỏ MediaQuery.of(context).size (trước Dòng 28)
Trước: final size = MediaQuery.of(context).size
Sau: không có
Lý do: MediaQuery rebuild khi đổi orientation, gây giật.
3) Dùng withValues() thay withOpacity() (Dòng 51)
Trước: withOpacity(0.05)
Sau: withValues(alpha: 0.05)
Lý do: withOpacity deprecated, tránh cảnh báo lint.
4) Fixed position thay percentage (Dòng 46–47)
Trước: bottom: size.height * 0.2
Sau: bottom: 200
Lý do: tránh tính lại, đơn giản hơn.
5) Tách _buildHeader(), _buildIllustration()
Trước: duplicate code x2
Sau: helper methods (Dòng 102–142)
Lý do: tránh duplicate, dễ bảo trì.
6) Bỏ Builder trong _buildHeader (Dòng 118–142)
Trước: có Builder dư
Sau: bỏ
Lý do: không cần context.
7) Thêm cache cho Image (Dòng 111–112)
Trước: không cache
Sau: cacheWidth: 320, cacheHeight: 320
Lý do: giảm memory, load nhanh hơn.
8) Dùng SingleChildScrollView cho mọi trường hợp (Dòng 96–99)
Trước: if với 2 nhánh
Sau: luôn dùng SingleChildScrollView
Lý do: cuộn ổn định khi mở bàn phím, tránh phức tạp.
Tổng: 190 → 144 dòng, ít rebuild, cuộn mượt hơn khi bàn phím mở.