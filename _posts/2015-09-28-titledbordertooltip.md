---
layout: post
category: swing
folder: TitledBorderToolTip
title: TitledBorderのタイトルが省略されている場合はToolTipを表示する
tags: [TitledBorder, JToolTip, JLabel]
author: aterai
pubdate: 2015-09-28T01:33:50+09:00
description: TitledBorderのタイトルが設定したコンポーネントの幅より長くなって末尾の文字列が省略される場合、JToolTipでタイトル全体を表示します。
comments: true
---
## 概要
`TitledBorder`のタイトルが設定したコンポーネントの幅より長くなって末尾の文字列が省略される場合、`JToolTip`でタイトル全体を表示します。

{% download https://lh3.googleusercontent.com/-_haLcd_rxx8/VggXa21_nHI/AAAAAAAAOCo/FLlSmRfIUqo/s800-Ic42/TitledBorderToolTip.png %}

## サンプルコード
<pre class="prettyprint"><code>JPanel panel1 = new JPanel() {
  private final JLabel label = new JLabel();
  @Override public String getToolTipText(MouseEvent e) {
    Border b = getBorder();
    if (b instanceof TitledBorder) {
      //int edge = 2; //EDGE_SPACING;
      TitledBorder titledBorder = (TitledBorder) b;
      Insets i = titledBorder.getBorderInsets(this);
      String title = titledBorder.getTitle();
      label.setFont(titledBorder.getTitleFont());
      label.setText(title);
      Dimension size = label.getPreferredSize();
      int labelX = i.left;
      int labelY = 0;
      int labelW = getSize().width - i.left - i.right;
      int labelH = i.top;
      if (size.width &gt; labelW) {
        Rectangle r = new Rectangle(labelX, labelY, labelW, labelH);
        return r.contains(e.getPoint()) ? title : null;
      }
    }
    return null; //super.getToolTipText(e);
  }
};
panel1.setBorder(BorderFactory.createTitledBorder("aaaaa...aaaaa"));
panel1.setToolTipText("JPanel: dummy");
</code></pre>

## 解説
- `TitledBorder`を設定する`JPanel`の`getToolTipText(...)`メソッドをオーバーライド
    - ダミーの`JLabel`に`TitledBorder`のフォントや文字列を設定して、その幅を`getPreferredSize()`で取得
        - `TitledBorder`で使用している`JLabel`は`private`なのでアクセスできない
    - ダミー`JLabel`の幅が`TitledBorder`を設定した`JPanel`の幅より長い場合、文字列が省略されていると判断する
    - 上記に加えて、マウスカーソルが`TitledBorder`の余白内(位置が`TOP`の場合)に存在する場、`TitledBorder#getTitle()`で取得したタイトルを返すことで、`JToolTip`を表示する
- 注:
    - このサンプルは、タイトルの位置が`TOP`の場合のみに対応
    - タイトルに`html`タグを使用し、省略ではなく折り返しが発生する場合には対応していない

<!-- dummy comment line for breaking list -->

## コメント