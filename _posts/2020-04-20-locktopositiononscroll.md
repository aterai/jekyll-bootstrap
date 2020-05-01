---
layout: post
category: swing
folder: LockToPositionOnScroll
title: JListのスクロールをセルユニット単位にするかを変更する
tags: [JList, JScrollPane, UIManager, LookAndFeel]
author: aterai
pubdate: 2020-04-20T03:08:08+09:00
description: JListのスクロールバーをマウスでドラッグした場合、セルの上辺を固定したユニット単位のスクロールかなめらなかにスクロールするかを設定します。
image: https://drive.google.com/uc?id=1KPtadNNLz1TOn7yjo-C8DpG6NuDpw-Od
comments: true
---
## 概要
`JList`のスクロールバーをマウスでドラッグした場合、セルの上辺を固定したユニット単位のスクロールかなめらなかにスクロールするかを設定します。

{% download https://drive.google.com/uc?id=1KPtadNNLz1TOn7yjo-C8DpG6NuDpw-Od %}

## サンプルコード
<pre class="prettyprint"><code>String key = "List.lockToPositionOnScroll";
// UIManager.put(key, Boolean.FALSE);

DefaultListModel&lt;String&gt; model = new DefaultListModel&lt;&gt;();
IntStream.range(0, 1000).mapToObj(Objects::toString).forEach(model::addElement);
JList&lt;String&gt; list = new JList&lt;String&gt;(model) {
  @Override public void updateUI() {
    setCellRenderer(null);
    super.updateUI();
    ListCellRenderer&lt;? super String&gt; renderer = getCellRenderer();
    setCellRenderer((list, value, index, isSelected, cellHasFocus) -&gt; {
      Component c = renderer.getListCellRendererComponent(
          list, value, index, isSelected, cellHasFocus);
      if (isSelected) {
        c.setForeground(list.getSelectionForeground());
        c.setBackground(list.getSelectionBackground());
      } else {
        c.setForeground(list.getForeground());
        c.setBackground(index % 2 == 0 ? EVEN_BACKGROUND : list.getBackground());
      }
      return c;
    });
  }
};
list.setFixedCellHeight(64);

JCheckBox check = new JCheckBox(key, UIManager.getBoolean(key));
check.addActionListener(e -&gt; UIManager.put(key, ((JCheckBox) e.getSource()).isSelected()));
</code></pre>

## 解説
- `WindowsLookAndFeel`
    - デフォルトは`UIManager.getBoolean("List.lockToPositionOnScroll")　== Boolean.TRUE`でセルの上辺を固定したユニット単位のスクロール
    - ホイールスクロールや矢印ボタンのクリック、カーソルキーなどのスクロールは`List.lockToPositionOnScroll`の設定は影響しない
        - [JScrollPaneのスクロール量を変更](https://ateraimemo.com/Swing/ScrollIncrement.html)
- `BasicLookAndFeel`
    - デフォルトは`UIManager.getBoolean("List.lockToPositionOnScroll")　== Boolean.FALSE`でなめらかにスクロール
    - `MetalLookAndFeel`は`UIManager.put("List.lockToPositionOnScroll", Boolean.TRUE)`を設定するとスクロールバーのマウスドラッグでもユニット単位のスクロールが可能
- `NumbusLookAndFeel`
    - `List.lockToPositionOnScroll`の設定は影響せず、スクロールバーのマウスドラッグはなめらかでもセルの上辺を固定したユニット単位のスクロールではなく、ホイールスクロールや矢印ボタンのクリックと同じスクロールになる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollPaneのスクロール量を変更](https://ateraimemo.com/Swing/ScrollIncrement.html)

<!-- dummy comment line for breaking list -->

## コメント
