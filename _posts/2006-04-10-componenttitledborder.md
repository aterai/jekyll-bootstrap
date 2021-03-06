---
layout: post
category: swing
folder: ComponentTitledBorder
title: BorderにJComponentを配置
tags: [Border, TitledBorder, JCheckBox, JButton]
author: aterai
pubdate: 2006-04-10T12:01:31+09:00
description: BorderにJCheckBoxやJButtonなどを配置します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKEdJmyzI/AAAAAAAAAVY/FTQKJ7__MnE/s800/ComponentTitledBorder.png
comments: true
---
## 概要
`Border`に`JCheckBox`や`JButton`などを配置します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKEdJmyzI/AAAAAAAAAVY/FTQKJ7__MnE/s800/ComponentTitledBorder.png %}

## サンプルコード
<pre class="prettyprint"><code>JCheckBox c = new JCheckBox("CheckBox", true);
c.setFocusPainted(false);
JLabel l1 = new JLabel("adfasdfasdfa");
Border eb = BorderFactory.createEtchedBorder();
l1.setBorder(new ComponentTitledBorder(c, l1, eb));
</code></pre>

## 解説
`SwingUtilities.paintComponent`で`Border`にコンポーネントを描画しているため、`JComboBox`などが選択されてもイベントが伝わりません。このため`ComponentTitledBorder`では、マウスリスナーを設定して`Component#dispatchEvent`メソッドで描画しているコンポーネントにマウスイベントを転送しています。

<pre class="prettyprint"><code>@Override public void mouseClicked(MouseEvent me) {
  Component src = me.getComponent();
  tgtCmp.dispatchEvent(SwingUtilities.convertMouseEvent(src, me, tgtCmp));
  src.repaint();
}
</code></pre>

## 参考リンク
- [ComponentTitledBorder](http://www.jroller.com/page/santhosh?entry=component_titled_border)
    - 参考にしていた[Santhosh Kumar's Weblog](http://www.jroller.com/page/santhosh)に接続できなくなっている
- [Borderの右下にJComponentを配置](https://ateraimemo.com/Swing/RightAlignComponentBorder.html)
- [TitledBorderにタイトル文字列までの内余白を設定する](https://ateraimemo.com/Swing/TitledBorderHorizontalInsetOfText.html)

<!-- dummy comment line for breaking list -->

## コメント
