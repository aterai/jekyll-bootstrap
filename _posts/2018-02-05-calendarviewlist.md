---
layout: post
category: swing
folder: CalendarViewList
title: JListで月のカーソルキー移動や、週を跨いた日付を範囲選択が可能なカレンダーを作成する
tags: [JList, LocalDate, ListModel, Calendar]
author: aterai
pubdate: 2018-02-05T15:56:39+09:00
description: JListを使用してカーソルキーで次の週や月に移動したり、週を跨いだLocalDate日付の範囲選択が可能なカレンダーを作成します。
image: https://drive.google.com/uc?id=1_8OMdhND7t1WDGW6aZl-xq9BV3ZUKNtCWQ
hreflang:
    href: https://java-swing-tips.blogspot.com/2018/02/create-range-selectable-calendar-with.html
    lang: en
comments: true
---
## 概要
`JList`を使用してカーソルキーで次の週や月に移動したり、週を跨いだ`LocalDate`日付の範囲選択が可能なカレンダーを作成します。

{% download https://drive.google.com/uc?id=1_8OMdhND7t1WDGW6aZl-xq9BV3ZUKNtCWQ %}

## サンプルコード
<pre class="prettyprint"><code>public final LocalDate realLocalDate = LocalDate.now();
public LocalDate currentLocalDate;
public final Dimension size = new Dimension(40, 26);

// ...
JLabel yearMonthLabel = new JLabel("", SwingConstants.CENTER);
JList&lt;LocalDate&gt; monthList = new JList&lt;LocalDate&gt;(new CalendarViewListModel(realLocalDate)) {
  @Override public void updateUI() {
    setCellRenderer(null);
    super.updateUI();
    setLayoutOrientation(JList.HORIZONTAL_WRAP);
    setVisibleRowCount(CalendarViewListModel.ROW_COUNT); // ensure 6 rows in the list
    setFixedCellWidth(size.width);
    setFixedCellHeight(size.height);
    setCellRenderer(new CalendarListRenderer&lt;&gt;());
    getSelectionModel().setSelectionMode(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
  }
};

// ...
class CalendarViewListModel extends AbstractListModel&lt;LocalDate&gt; {
  public static final int ROW_COUNT = 6;
  private final LocalDate startDate;
  private final WeekFields weekFields = WeekFields.of(Locale.getDefault());
  protected CalendarViewListModel(LocalDate date) {
    super();
    LocalDate firstDayOfMonth = YearMonth.from(date).atDay(1);
    int dowv = firstDayOfMonth.get(weekFields.dayOfWeek()) - 1;
    startDate = firstDayOfMonth.minusDays(dowv);
  }

  @Override public int getSize() {
    return DayOfWeek.values().length * ROW_COUNT;
  }

  @Override public LocalDate getElementAt(int index) {
    return startDate.plusDays(index);
  }
}
</code></pre>

## 解説
カレンダーの週や日付モデルは、[JTableにLocaleを考慮したLocalDateを適用してカレンダーを表示する](https://ateraimemo.com/Swing/CalendarViewTable.html)とほぼ同じですが、上記のサンプルでは表示に`JTable`ではなく`JList`を使用しているため、左右カーソルキーでの週を跨いだ日付移動などが可能になっています。

- `JList#setLayoutOrientation(JList.HORIZONTAL_WRAP)`を設定し、セルが水平方向の次に垂直方向の順で並ぶ「ニュースペーパー・スタイル」レイアウトを使用
- セルサイズは、`JList#setFixedCellWidth(int)`と`JList#setFixedCellHeight(int)`メソッドで固定サイズを使用
- 折り返しセル数は、`JList#setVisibleRowCount(int)`メソッドを使用して表示可能行数を設定することで指定
    - `HORIZONTAL_WRAP`を指定した`JList`の場合、列数を指定した折り返しはできないため、`7`列`6`行の固定サイズのカレンダーで`JList#setVisibleRowCount(6)`を設定することで常に`7`日分の列を表示する
- `HORIZONTAL_WRAP`を指定した`JList`の場合、例えば右カーソルキーで土曜から日曜に移動できないため、デフォルトの`selectNextColumn`アクションではなく、以下のようなアクションを使用するようにマッピングを変更
    - 現在の月内なら`HORIZONTAL_WRAP`を無視して、単純に次の日付に選択状態を移動
    - 月表示を変更する必要がある場合は、移動先の月で次の日付に選択状態を移動
        
        <pre class="prettyprint"><code>monthList.getActionMap().put("selectNextIndex", new AbstractAction() {
          @Override public void actionPerformed(ActionEvent e) {
            int index = monthList.getLeadSelectionIndex();
            if (index &lt; monthList.getModel().getSize() - 1) {
              monthList.setSelectedIndex(index + 1);
            } else {
              LocalDate d = monthList.getModel()
                .getElementAt(monthList.getModel().getSize() - 1)
                .plusDays(1);
              updateMonthView(currentLocalDate.plusMonths(1));
              monthList.setSelectedValue(d, false);
            }
          }
        });
</code></pre>
    - * 参考リンク [#reference]
- [JTableにLocaleを考慮したLocalDateを適用してカレンダーを表示する](https://ateraimemo.com/Swing/CalendarViewTable.html)
- [JListでウィークカレンダーを作成してヒートマップを表示する](https://ateraimemo.com/Swing/CalendarHeatmapList.html)
    - セルが垂直方向の次に水平方向の順で並ぶ「ニュースペーパー・スタイル」レイアウトの`JList`で週カレンダーを表示

<!-- dummy comment line for breaking list -->

## コメント
