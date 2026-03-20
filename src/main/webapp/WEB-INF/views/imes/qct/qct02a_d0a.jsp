<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)qct02a_d0a.jsp 1.0 2026/03/09                                    --%>
<%--                                                                        --%>
<%-- 부적합 사진보기 팝업 (D0A) - href 방식 동적 로드                        --%>
<%-- 이미지 4개 (사진1~사진4) 가로 배치                                      --%>
<%-- @author 송우석                                                         --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<div style="padding:10px;">
    <table style="width:100%; table-layout:fixed;">
        <tr>
            <th style="text-align:center; padding:5px; background-color:#f5f5f5; border:1px solid #ddd;">사진1</th>
            <th style="text-align:center; padding:5px; background-color:#f5f5f5; border:1px solid #ddd;">사진2</th>
            <th style="text-align:center; padding:5px; background-color:#f5f5f5; border:1px solid #ddd;">사진3</th>
            <th style="text-align:center; padding:5px; background-color:#f5f5f5; border:1px solid #ddd;">사진4</th>
        </tr>
        <tr>
            <td style="text-align:center; vertical-align:middle; padding:5px; border:1px solid #ddd; height:220px;">
                <img id="d0a-img1" class="ng-img-cell" style="display:none;" />
                <span id="d0a-img1-empty" style="color:#999;">이미지 없음</span>
            </td>
            <td style="text-align:center; vertical-align:middle; padding:5px; border:1px solid #ddd; height:220px;">
                <img id="d0a-img2" class="ng-img-cell" style="display:none;" />
                <span id="d0a-img2-empty" style="color:#999;">이미지 없음</span>
            </td>
            <td style="text-align:center; vertical-align:middle; padding:5px; border:1px solid #ddd; height:220px;">
                <img id="d0a-img3" class="ng-img-cell" style="display:none;" />
                <span id="d0a-img3-empty" style="color:#999;">이미지 없음</span>
            </td>
            <td style="text-align:center; vertical-align:middle; padding:5px; border:1px solid #ddd; height:220px;">
                <img id="d0a-img4" class="ng-img-cell" style="display:none;" />
                <span id="d0a-img4-empty" style="color:#999;">이미지 없음</span>
            </td>
        </tr>
    </table>
</div>
