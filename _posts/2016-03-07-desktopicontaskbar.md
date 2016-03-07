---
layout: post
category: swing
folder: DesktopIconTaskBar
title: JDesktopPaneにTaskBarを配置してJInternalFrameの一覧を表示する
tags: [JDesktopPane, JInternalFrame, NimbusLookAndFeel]
author: aterai
pubdate: 2016-03-07T09:09:57+09:00
description: AffineTransformで図形や画像を反転して表示します。
comments: true
---
## JDesktopPaneにTaskBarを配置してJInternalFrameの一覧を表示する
`JDesktopPane`に追加されている`JInternalFrame`の一覧を表示するタスクバーを設定します。

{% download https://lh3.googleusercontent.com/-RFRKt-CvY4E/VtzC8EelOgI/AAAAAAAAOQQ/NK8GMY49kGY/s800-Ic42/DesktopIconTaskBar.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("InternalFrame.useTaskBar", Boolean.TRUE);
</code></pre>

## 解説
上記のサンプルでは、`JDesktopPane`に追加されている`JInternalFrame`の一覧を表示するタスクバーを使用するかどうかを、`UIManager.put("InternalFrame.useTaskBar", ...);`で切り替えています。

- `InternalFrame.useTaskBar`が有効かどうかは、`LoolAndFeel`に依存する
    - `NimbusLookAndFeel`は有効で、`JInternalFrame`がアイコン化されているかどうかにかかわらず、`TaskBar`にその一覧が表示される
    - また、`JInternalFrame`がアイコン化されている場合でも、その`DesktopIcon`は`TaskBar`から移動できない

<!-- dummy comment line for breaking list -->

## コメント
