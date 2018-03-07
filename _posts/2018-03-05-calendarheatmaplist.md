---
layout: post
category: swing
folder: CalendarHeatmapList
title: JListでウィークカレンダーを作成してヒートマップを表示する
tags: [JList, LocalDate, ListModel, Calendar, Icon]
author: aterai
pubdate: 2018-03-05T17:08:51+09:00
description: JListを垂直方向ニュースペーパー・スタイルレイアウトに設定してウィークカレンダーを作成し、これにヒートマップを表示します。
image: https://drive.google.com/uc?id=1nuJgXoB7AW6ndK0nG_xUtriaxwJAt5N53Q
comments: true
---
## 概要
`JList`を垂直方向ニュースペーパー・スタイルレイアウトに設定してウィークカレンダーを作成し、これにヒートマップを表示します。

{% download https://drive.google.com/uc?id=1nuJgXoB7AW6ndK0nG_xUtriaxwJAt5N53Q %}

## サンプルコード
<pre class="prettyprint"><code>JList&lt;Contribution&gt; weekList = new JList&lt;Contribution&gt;() {
  @Override public void updateUI() {
    setCellRenderer(null);
    super.updateUI();
    setLayoutOrientation(JList.VERTICAL_WRAP);
    setVisibleRowCount(DayOfWeek.values().length); // ensure 7 rows in the list
    setFixedCellWidth(size.width);
    setFixedCellHeight(size.height);
    setCellRenderer(new ContributionListRenderer());
    getSelectionModel().setSelectionMode(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
    setBorder(BorderFactory.createEmptyBorder(2, 2, 2, 2));
  }
};
//...
private class ContributionListRenderer implements ListCellRenderer&lt;Contribution&gt; {
  private final Icon emptyIcon = new ColorIcon(Color.WHITE);
  private final ListCellRenderer&lt;? super Contribution&gt; renderer
    = new DefaultListCellRenderer();
  @Override public Component getListCellRendererComponent(
      JList&lt;? extends Contribution&gt; list, Contribution value, int index,
      boolean isSelected, boolean cellHasFocus) {
    JLabel l = (JLabel) renderer.getListCellRendererComponent(
        list, null, index, isSelected, cellHasFocus);
    if (value.date.isAfter(currentLocalDate)) {
      l.setIcon(emptyIcon);
      l.setToolTipText(null);
    } else {
      l.setIcon(activityIcons.get(value.activity));
      String actTxt = value.activity == 0 ? "No" : Objects.toString(value.activity);
      l.setToolTipText(actTxt + " contribution on " + value.date.toString());
    }
    return l;
  }
}
</code></pre>

## 解説
上記のサンプルでは、セルが垂直方向の次に水平方向の順で並ぶ「ニュースペーパー・スタイル」レイアウトの`JList`を使用して、`GitHub`で表示されている`Contribution activity`風のヒートマップカレンダーを作成しています。

- `1`列で`1`週間になるよう、`JList.VERTICAL_WRAP`スタイルでの行数を`JList#setVisibleRowCount(7)`で指定
- `WeekFields#getFirstDayOfWeek()`メソッドで`Locale`に応じた週の最初の曜日を取得して、`JList`の`0`行目を設定
    
    <pre class="prettyprint"><code>public static final int WEEK_VIEW = 27;
    //...
    WeekFields weekFields = WeekFields.of(Locale.getDefault());
    int dow = today.get(weekFields.dayOfWeek()) - 1;
    startDate = today.minusWeeks(WEEK_VIEW - 1).minusDays(dow);
</code></pre>
- 表示される週は、約半年分の`27`週に設定
    - `JList`の`index = 0`となるセルの日付は、`27`週から今週の`1`週間分を引いた`26`週前を`today.minusWeeks(26)`で取得し、さらに今日が週の何番目かを引いて求めている
        - 週番号を`today.get(weekFields.dayOfWeek())`で取得すると最初の曜日が`1`から始まるので、これを`-1`して最初の曜日が`JList`の`0`行目からになるよう変更
- ヒートマップは、テキストを空にして色アイコンを設定した`JLabel`を`ListCellRenderer#getListCellRendererComponent(...)`メソッドで返すことで表示
    - 各日付の色は`4`段階のランダムで生成したダミー
    - ツールチップテキストも、この`ListCellRenderer`の`JLabel`に設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JListで月のカーソルキー移動や、週を跨いた日付を範囲選択が可能なカレンダーを作成する](https://ateraimemo.com/Swing/CalendarViewList.html)
    - こちらはセルが水平方向の次に垂直方向の順で並ぶ「ニュースペーパー・スタイル」レイアウトの`JList`で月カレンダーを表示
- [Harmonic Code: Friday Fun XLVIII - Calendar Heatmap](https://harmoniccode.blogspot.jp/2017/10/friday-fun-xlviii-calendar-heatmap.html)

<!-- dummy comment line for breaking list -->

## コメント
