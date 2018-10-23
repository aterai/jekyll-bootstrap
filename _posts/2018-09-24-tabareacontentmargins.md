---
layout: post
category: swing
folder: TabAreaContentMargins
title: JTabbedPaneのタブエリアに余白を設定する
tags: [JTabbedPane, NimbusLookAndFeel]
author: aterai
pubdate: 2018-09-24T22:51:27+09:00
description: JTabbedPaneのタブエリア余白を取得、変更するテストを行います。
image: https://drive.google.com/uc?export=view&id=1WORPot3oeRdnLbFIDh6BcBmJpFVrLASoOw
comments: true
---
## 概要
`JTabbedPane`のタブエリア余白を取得、変更するテストを行います。

{% download https://drive.google.com/uc?export=view&id=1WORPot3oeRdnLbFIDh6BcBmJpFVrLASoOw %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.setLookAndFeel("javax.swing.plaf.nimbus.NimbusLookAndFeel");
UIDefaults d = UIManager.getLookAndFeelDefaults();
// d.put("TabbedPane:TabbedPaneContent.contentMargins", new Insets(0, 5, 5, 5));
// d.put("TabbedPane:TabbedPaneTab.contentMargins", new Insets(2, 8, 3, 8));
// d.put("TabbedPane:TabbedPaneTabArea.contentMargins", new Insets(3, 10, 4, 10));
Insets i = d.getInsets("TabbedPane:TabbedPaneTabArea.contentMargins");
d.put("TabbedPane:TabbedPaneTabArea.contentMargins", new Insets(i.top, 0, i.bottom, 0));
</code></pre>

## 解説
上記のサンプルでは、`NimbusLookAndFeel`を設定した`JTabbedPane`のタブエリア余白を設定するテストを行っています。

- 上:
    - すべての`JTabbedPane`のタブエリア左右の余白を`0`にして除去
    - `UIManager.getLookAndFeelDefaults()`で取得した`UIDefaults`に`UIDefaults#put("TabbedPane:TabbedPaneTabArea.contentMargins", new Insets(i.top, 0, i.bottom, 0))`ですべての`JTabbedPane`のタブエリアの余白を上書き
- 下:
    - 特定`JTabbedPane`のタブエリア左右の余白を`30`に拡大
    - `new UIDefaults()`で生成した`UIDefaults`に`UIDefaults#put("TabbedPane:TabbedPaneTabArea.contentMargins", new Insets(3, 30, 4, 30))`でタブエリアの余白を設定し、`putClientProperty("Nimbus.Overrides", d)`メソッドで特定の`JTabbedPane`のタブエリア余白を上書き
        
        <pre class="prettyprint"><code>UIDefaults d = new UIDefaults();
        d.put("TabbedPane:TabbedPaneTabArea.contentMargins", new Insets(3, 30, 4, 30));
        tabbedPane.putClientProperty("Nimbus.Overrides", d);
        tabbedPane.putClientProperty("Nimbus.Overrides.InheritDefaults", true);
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `MetalLookAndFeel`や`WindowsLookAndFeel`などでタブエリア余白を設定する場合は、`UIManager.put("TabbedPane.tabAreaInsets", new Insets(...))`が使用可能

<!-- dummy comment line for breaking list -->

- - - -
- `LookAndFeel`によってタブエリアの余白を取得可能な方法が異なるので注意する必要がある
    
    <pre class="prettyprint"><code>// MetalLookAndFeelなどではnullになる
    // UIDefaults d = UIManager.getLookAndFeelDefaults();
    // Insets i = d.getInsets("TabbedPane:TabbedPaneTabArea.contentMargins");
    
    // NimbusLookAndFeelなどではnullになる
    Insets insets = UIManager.getInsets("TabbedPane.tabAreaInsets");
    if (Objects.nonNull(insets)) {
      return insets;
    } else {
      // MetalLookAndFeelなどでは使用できない
      SynthStyle style = SynthLookAndFeel.getStyle(this, Region.TABBED_PANE_TAB_AREA);
      SynthContext context = new SynthContext(this, Region.TABBED_PANE_TAB_AREA, style, SynthConstants.ENABLED);
      return style.getInsets(context, null);
    }
</code></pre>
- * 参考リンク [#reference]
- [JTabbedPaneのNimbusLookAndFeelにおけるスタイルを変更する](https://ateraimemo.com/Swing/NimbusTabbedPanePainter.html)
- [JTabbedPaneのタイトルをクリップ](https://ateraimemo.com/Swing/ClippedTabLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
