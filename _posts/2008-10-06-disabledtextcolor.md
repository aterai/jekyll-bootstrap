---
layout: post
title: JCheckBoxなどが無効な状態での文字色を変更
category: swing
folder: DisabledTextColor
tags: [JCheckBox, JComboBox, UIManager, Html, JLabel, JButton]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-10-06

## 概要
`JCheckBox`や`JComboBox`などのコンポーネントが無効な状態になった場合の文字色を変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLDPDIq4I/AAAAAAAAAW8/jt2A5D74G04/s800/DisabledTextColor.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("CheckBox.disabledText", Color.RED);
JCheckBox cbx1 = new JCheckBox("default", true);
JCheckBox cbx2 = new JCheckBox("&lt;html&gt;html tag&lt;/html&gt;", true);
</code></pre>

## 解説
- `JCheckBox`
    - `UIManager.put("CheckBox.disabledText", Color.RED)`
        - `MetalLookAndFeel`でのみ？、反映される
- `JCheckBox` + `html`
    - `<html>`タグを使った場合、`setEnable`にかかわらず、文字色は変更不可([Bug ID: 4740519 HTML JLabel not greyed out on setEnabled(false)](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4740519))を利用
        - 参考:[Swing - How to disable a JCheckBox and leave the text the original color?](https://forums.oracle.com/thread/1359798)のMichael_Dunn さんの投稿
        - [Htmlを使ったJLabelとJEditorPaneの無効化](http://terai.xrea.jp/Swing/DisabledHtmlLabel.html)
- `JComboBox`
    - `UIManager.put("ComboBox.disabledForeground", Color.GREEN);`
- `JComboBox` + `html`
    - レンダラーで文字色を変更
- `JComboBox`(`Editable`)
    - `EditorComponent`を取得して、`editor.setDisabledTextColor(Color.PINK);`を設定
- `JLabel`
    - `UIManager.put("Label.disabledForeground", Color.ORANGE);`
- `JButton`
    - `UIManager.put("Button.disabledText", Color.YELLOW)`
        - `MetalLookAndFeel`でのみ？、反映される

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLFT1HGFI/AAAAAAAAAXA/W5L-yIFc61E/s800/DisabledTextColor1.png)

## コメント
