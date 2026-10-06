#!/bin/bash
A="ThanhTinh"; B="NhiDamDang"; C="Tram0Dam"

# Nhãn
gh label create ai          --color 8250df --description "Dữ liệu, mô hình, chatbot RAG" --force
gh label create backend     --color 0969da --description "API, CSDL, tích hợp" --force
gh label create frontend    --color 1a7f37 --description "Giao diện web/mobile" --force
gh label create docs        --color bf8700 --description "Báo cáo, tài liệu, thiết kế" --force
gh label create must-have   --color cf222e --description "Bắt buộc trong MVP" --force
gh label create should-have --color fb8500 --description "Nên có" --force
gh label create later       --color 6e7781 --description "Làm sau nếu còn thời gian" --force

mk() { # tiêu đề | nhãn | người phụ trách | mô tả
  gh issue create --title "$1" --label "$2" --assignee "$3" --body "$4"
}

mk "[F1] Nhận diện rác bằng ảnh" "ai,backend,frontend,must-have" "$A,$B,$C" \
"Người dùng chụp/tải ảnh, hệ thống trả loại rác kèm độ tin cậy.

- [ ] (AI) Huấn luyện và xuất mô hình
- [ ] (BE) Endpoint POST /predict
- [ ] (FE) Màn hình chụp/tải ảnh và hiển thị kết quả"

mk "[F2] Gợi ý thùng bỏ và cách xử lý/tái chế" "backend,frontend,docs,must-have" "$B,$C" \
"- [ ] (Docs) Bảng ánh xạ lớp rác → nhóm theo luật → hướng dẫn
- [ ] (BE) Lưu tri thức và gắn vào kết quả /predict
- [ ] (FE) Hiển thị thẻ hướng dẫn"

mk "[F3] Chatbot hỏi đáp phân loại, tái chế" "ai,backend,frontend,must-have" "$B,$A,$C" \
"- [ ] (AI) Chuẩn bị tài liệu tri thức và embedding
- [ ] (BE) Endpoint POST /chat
- [ ] (FE) Giao diện khung chat"

mk "[F4] Đăng ký, đăng nhập" "backend,frontend,must-have" "$B,$C" \
"- [ ] (BE) Bảng users, JWT, /auth/register, /auth/login
- [ ] (FE) Form đăng ký, đăng nhập"

mk "[F5] Lịch sử phân loại" "backend,frontend,must-have" "$B,$C" \
"- [ ] (BE) Lưu mỗi lần nhận diện, GET /history có phân trang
- [ ] (FE) Trang danh sách lịch sử"

mk "[F6] Thống kê lượng rác" "backend,frontend,should-have" "$C,$B" \
"Phụ thuộc F5.
- [ ] (BE) GET /stats
- [ ] (FE) Biểu đồ theo loại và thời gian"

mk "[F7] Xác nhận/sửa kết quả AI" "ai,backend,frontend,should-have" "$C,$B,$A" \
"- [ ] (FE) Nút 'Kết quả sai?' và chọn lại nhãn
- [ ] (BE) Lưu nhãn người dùng sửa
- [ ] (AI) Dùng dữ liệu sửa để phân tích lỗi"

mk "[F8] Điểm thưởng, huy hiệu" "backend,frontend,later" "$B,$C" \
"Làm sau khi F1-F7 ổn định."

mk "[F9] Bản đồ điểm thu gom" "frontend,backend,later" "$C" \
"Làm sau khi F1-F7 ổn định."

mk "[F10] Trang quản trị cơ sở tri thức" "backend,frontend,later" "$B" \
"Có thể thay bằng nhập dữ liệu trực tiếp vào CSDL nếu thiếu thời gian."
