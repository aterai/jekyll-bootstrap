---
layout: post
category: swing
folder: SameSizeButtons
title: JOptionPaneで使用するボタンのサイズを揃える
tags: [JOptionPane, JButton, UIManager, NimbusLookAndFeel]
author: aterai
pubdate: 2015-05-11T00:39:58+09:00
description: NimbusLookAndFeelでJOptionPaneを使用した場合、そのJButtonのサイズを揃えるかどうかを設定します。
image: https://lh3.googleusercontent.com/-vidT_rr0mcE/VU97kF6HGpI/AAAAAAAAN4A/ByrWGh41AQg/s800/SameSizeButtons.png
comments: true
---
## 概要
`NimbusLookAndFeel`で`JOptionPane`を使用した場合、その`JButton`のサイズを揃えるかどうかを設定します。[java - JOptionPane button size (Nimbus LAF) - Stack Overflow](http://stackoverflow.com/questions/30138984/joptionpane-button-size-nimbus-laf)の回答を参考にしています。

{% download https://lh3.googleusercontent.com/-vidT_rr0mcE/VU97kF6HGpI/AAAAAAAAN4A/ByrWGh41AQg/s800/SameSizeButtons.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.getLookAndFeelDefaults().put("OptionPane.sameSizeButtons", true);
</code></pre>

## 解説
- `default`
    - デフォルトの`NimbusLookAndFeel`で`JOptionPane`が使用する`JButton`のサイズは、各ボタンのテキストの長さに依存する
    - 注: `MetalLookAndFeel`などは、常にこれらのボタンは同じサイズ
- `SameSizeButtons`
    - `UIManager.getLookAndFeelDefaults().put("OptionPane.sameSizeButtons", true);`で、最も長いボタンテキストから作成される`JButton`のサイズに揃えられる
    - 注: このサンプルでは、実行中にこれらを切り替えるテストを行うために、`UIManager.getLookAndFeelDefaults()`で取得した`UIDefaults`ではなく、以下のように新規作成した`UIDefaults`に`OptionPane.sameSizeButtons`を設定して`JOptionPane`に上書きし、`SwingUtilities.updateComponentTreeUI(JOptionPane)`で`UI`を更新している(`OptionPane.buttonAreaBorder`でテスト)
        
        <pre class="prettyprint"><code>UIDefaults d = new UIDefaults();
        d.put("OptionPane.sameSizeButtons", true);
        op.putClientProperty("Nimbus.Overrides", d);
        op.putClientProperty("Nimbus.Overrides.InheritDefaults", true);
        SwingUtilities.updateComponentTreeUI(op);
        op.createDialog(getRootPane(), "title").setVisible(true);
</code></pre>
    - * 参考リンク [#reference]
- [java - JOptionPane button size (Nimbus LAF) - Stack Overflow](http://stackoverflow.com/questions/30138984/joptionpane-button-size-nimbus-laf)
- [JOptionPane固有のプロパティ](http://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/synth/doc-files/componentProperties.html)
- [Nimbusの外観をUIDefaultsで変更する](http://ateraimemo.com/Swing/UIDefaultsOverrides.html)
- [JButtonなどの高さを変更せずに幅を指定](http://ateraimemo.com/Swing/ButtonWidth.html)

<!-- dummy comment line for breaking list -->

## コメント
