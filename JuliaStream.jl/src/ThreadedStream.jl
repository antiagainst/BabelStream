include("Stream.jl")

function devices()::Vector{DeviceWithRepr}
  return [(undef, "$(Sys.cpu_info()[1].model) ($(Threads.nthreads())T)", "Threaded")]
end

function make_stream(
  arraysize::Int,
  scalar::T,
  _::DeviceWithRepr,
  silent::Bool,
)::Tuple{VectorData{T},Nothing} where {T}
  if !silent
    println("Using max $(Threads.nthreads()) threads")
  end
  return (
    VectorData{T}(
      Vector{T}(undef, arraysize),
      Vector{T}(undef, arraysize),
      Vector{T}(undef, arraysize),
      scalar,
      arraysize,
    ),
    nothing
  )
end

function init_arrays!(data::VectorData{T}, _, init::Tuple{T,T,T}) where {T}
  Threads.@threads for i = 1:data.size
    @inbounds data.a[i] = init[1]
    @inbounds data.b[i] = init[2]
    @inbounds data.c[i] = init[3]
  end
end

function copy!(data::VectorData{T}, _) where {T}
  Threads.@threads for i = 1:data.size
    @inbounds data.c[i] = data.a[i]
  end
end

function mul!(data::VectorData{T}, _) where {T}
  Threads.@threads for i = 1:data.size
    @inbounds data.b[i] = data.scalar * data.c[i]
  end
end

function add!(data::VectorData{T}, _) where {T}
  Threads.@threads for i = 1:data.size
    @inbounds data.c[i] = data.a[i] + data.b[i]
  end
end

function triad!(data::VectorData{T}, _) where {T}
  Threads.@threads for i = 1:data.size
    @inbounds data.a[i] = data.b[i] + (data.scalar * data.c[i])
  end
end

function nstream!(data::VectorData{T}, _) where {T}
  Threads.@threads for i = 1:data.size
    @inbounds data.a[i] += data.b[i] + data.scalar * data.c[i]
  end
end

function dot(data::VectorData{T}, _) where {T}
  partial = zeros(T, Threads.nthreads())
  Threads.@threads for i = 1:data.size
    @inbounds partial[Threads.threadid()] += data.a[i] * data.b[i]
  end
  return sum(partial)
end

function read_data(data::VectorData{T}, _)::VectorData{T} where {T}
  return data
end

main()