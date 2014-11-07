---
layout: post
category: swing
folder: DisableScrolling
title: JScrollPaneのスクロールを禁止
tags: [JScrollPane, JScrollBar]
author: aterai
pubdate: 2005-10-03
description: JScrollPaneのスクロールを一時的に禁止します。
comments: true
---
## 概要
`JScrollPane`のスクロールを一時的に禁止します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLM6S99OI/AAAAAAAAAXM/9r2e_2JRA5g/s800/DisableScrolling.png %}

## サンプルコード
<pre class="prettyprint"><code>JCheckBox check = new JCheckBox("Disable Scrolling");
check.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent ie) {
    table.clearSelection();
    JScrollBar bar = scroll.getVerticalScrollBar();
    if (ie.getStateChange() == ItemEvent.SELECTED) {
      bar.setEnabled(false);
      scroll.setWheelScrollingEnabled(false);
      table.setEnabled(false);
    } else if (ie.getStateChange() == ItemEvent.DESELECTED) {
      bar.setEnabled(true);
      scroll.setWheelScrollingEnabled(true);
      table.setEnabled(true);
    }
  }
});
</code></pre>

## 解説
- このサンプルでは、`Disable Scrolling`をチェックして無効状態にすると
    - スクロールバーを取得し、`JScrollBar#setEnabled(boolean)`メソッドを使って、これを無効にします。
    - `JScrollPane#setWheelScrollingEnabled(boolean)`メソッドで、マウスホイールによるスクロールを無効にします。
    - `JScrollPane`に配置したコンポーネントを`setEnabled(false)`とし、フォーカスの移動などによるスクロールを無効にします。

<!-- dummy comment line for breaking list -->

- - - -
- このサンプルでは、`Disable Scrolling`をチェックして無効状態にしても
    - `JTableHeader`は無効にしていないので、クリックしてソートや、カラムの移動を行うことができます。
    - `JScrollPane`に設定した`JPopupMenu`を表示することができます。
    - `JTable`に設定した`JToolTip`を表示することができます。

<!-- dummy comment line for breaking list -->

- - - -
`JDK 1.7.0`で追加された`JLayer`を使用して、以下のように入力を禁止する方法もあります。

- [JLayerで子コンポーネントへの入力を制限する](http://ateraimemo.com/Swing/PopupMenuBlockLayer.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLayerで子コンポーネントへの入力を制限する](http://ateraimemo.com/Swing/PopupMenuBlockLayer.html)
- [JLayerで指定したコンポーネントへの入力を禁止](http://ateraimemo.com/Swing/DisableInputLayer.html)

<!-- dummy comment line for breaking list -->

## コメント
