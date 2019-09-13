---
layout: post
category: swing
folder: TabbedPaneLabelShift
title: JTabbedPaneのタブのテキストシフト量を変更する
tags: [JTabbedPane, UIManager]
author: aterai
pubdate: 2018-09-17T16:31:38+09:00
description: JTabbedPaneの選択状態でのタブテキストシフト量などを変更します。
image: https://drive.google.com/uc?id=1h-7B_-q-8VbEv-cpGzX6hQFdOcf8KgT9LA
comments: true
---
## 概要
`JTabbedPane`の選択状態でのタブテキストシフト量などを変更します。

{% download https://drive.google.com/uc?id=1h-7B_-q-8VbEv-cpGzX6hQFdOcf8KgT9LA %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("TabbedPane.selectedLabelShift", -1);
UIManager.put("TabbedPane.labelShift", 1);
</code></pre>

## 解説
上記のサンプルでは、`Java 1.6.0`から導入された`TabbedPane.selectedLabelShift`と`TabbedPane.labelShift`を使用して`JTabbedPane`の選択状態タブのテキストシフト量を変更するテストが可能です。

テキストだけではなくタブアイコンや`JTabbedPane#setTabComponentAt(...)`で設定したタブコンポーネントも同様にシフトします。

移動方向はマイナスでタブの外側、プラスでタブの内側になり、例えばタブ位置がデフォルトの`JTabbedPane.TOP`の場合はマイナスで上方向、プラスで下方向にシフトします。

- `TabbedPane.selectedLabelShift`
    - 選択状態タブのテキストシフト量
    - `WindowsLookAndFeel`でのデフォルトは`-1`
- `TabbedPane.labelShift`
    - 非選択状態タブのテキストシフト量
    - `WindowsLookAndFeel`でのデフォルトは`1`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JDK-7010561 Tab text position with Synth based LaF is different to Java 5/6 - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-7010561)
- [JButtonのテキストシフト量を変更](https://ateraimemo.com/Swing/TextShiftOffset.html)

<!-- dummy comment line for breaking list -->

## コメント
