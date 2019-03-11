---
layout: post
category: swing
folder: BreadcrumbList
title: FlowLayoutでボタンを重ねてパンくずリストを作成する
tags: [FlowLayout, JRadioButton, JPanel, Shape, Icon]
author: aterai
pubdate: 2013-12-02T00:03:12+09:00
description: FlowLayoutの水平間隔をマイナスにして、JRadioButtonを重ねて表示し、パンくずリスト風のコンポーネントを作成します。
hreflang:
    href: http://java-swing-tips.blogspot.com/2013/12/breadcrumb-navigation-with-jradiobutton.html
    lang: en
comments: true
---
## 概要
`FlowLayout`の水平間隔をマイナスにして、`JRadioButton`を重ねて表示し、パンくずリスト風のコンポーネントを作成します。

{% download https://lh5.googleusercontent.com/-aKK_2LaPfVQ/UpsqWSS4lUI/AAAAAAAAB7c/VSzPRuRu3IY/s800/BreadcrumbList.png %}

## サンプルコード
<pre class="prettyprint"><code>private static JComponent makeBreadcrumbList(int overlap, List&lt;String&gt; list) {
  JPanel p = new JPanel(new FlowLayout(FlowLayout.LEADING, -overlap, 0));
  p.setBorder(BorderFactory.createEmptyBorder(4, overlap + 4, 4, 4));
  p.setOpaque(false);
  ButtonGroup bg = new ButtonGroup();
  for (String title: list) {
    AbstractButton b = makeButton(title, Color.PINK);
    p.add(b);
    bg.add(b);
  }
  return p;
}
</code></pre>

## 解説
上記のサンプルでは、指定したピクセル分だけ重なるように、`FlowLayout`の水平間隔にマイナスの値を指定しています。このため、左側の`JRadioButton`の下に右側の`JRadioButton`が配置されている状態になっています。各`JRadioButton`自体は重なっていますが、描画やマウスクリックなどは重ならないよう、以下のような設定を追加しています。

- 描画
    - 矢羽型のアイコンを設定、このアイコン以外は、`setContentAreaFilled(false);`などで透明化
- マウスクリック
    - `JRadioButton#contains(...)`をオーバーライドして、上記の矢羽図形の外では反応しないよう設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JRadioButtonを使ってToggleButtonBarを作成](http://ateraimemo.com/Swing/ToggleButtonBar.html)
- [JMenuItemの内部にJButtonを配置する](http://ateraimemo.com/Swing/ButtonsInMenuItem.html)
    - 前後のコンポーネントのフチを共通化して(`1px`だけ重ねる)、`JLayer`でそのフォーカスを描画するサンプル

<!-- dummy comment line for breaking list -->

## コメント
