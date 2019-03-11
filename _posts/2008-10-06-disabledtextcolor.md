---
layout: post
category: swing
folder: DisabledTextColor
title: JCheckBoxなどが無効な状態での文字色を変更
tags: [JCheckBox, JComboBox, UIManager, Html, JLabel, JButton]
author: aterai
pubdate: 2008-10-06T14:59:33+09:00
description: JCheckBoxやJComboBoxなどのコンポーネントが無効な状態になった場合の文字色を変更します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLDPDIq4I/AAAAAAAAAW8/jt2A5D74G04/s800/DisabledTextColor.png
comments: true
---
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
    - `JDK 1.7.0`で以下の動作は修正され、無効化で`HTML`文字列もグレーになる([Bug ID: 4783068 Components with HTML text should gray out the text when disabled](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4783068))
    - ~~`<html>`タグを使った場合、文字色は常に不変で`isEnabled()`の状態に依存しない([Bug ID: 4740519 HTML JLabel not greyed out on setEnabled(false)](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4740519))を利用~~
        - 参考: [Swing - How to disable a JCheckBox and leave the text the original color?](https://community.oracle.com/thread/1359798)のMichael_Dunn さんの投稿
        - [Htmlを使ったJLabelとJEditorPaneの無効化](http://ateraimemo.com/Swing/DisabledHtmlLabel.html)
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
        - `MetalLookAndFeel`でのみ反映

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLFT1HGFI/AAAAAAAAAXA/W5L-yIFc61E/s800/DisabledTextColor1.png)

## 参考リンク
- [Bug ID: 4740519 HTML JLabel not greyed out on setEnabled(false)](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4740519)
- [Swing - How to disable a JCheckBox and leave the text the original color?](https://community.oracle.com/thread/1359798)
- [Bug ID: 4783068 Components with HTML text should gray out the text when disabled](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=4783068)
- [Htmlを使ったJLabelとJEditorPaneの無効化](http://ateraimemo.com/Swing/DisabledHtmlLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
